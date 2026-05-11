//
//  WebSocketClient.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

final class WebSocketClient: WebSocketClientProvidable {
    
    // MARK: Private Properties
    private let url: URL
    private let session: URLSession
    private var socketTask: URLSessionWebSocketTask?
    private var latestConnectionStatus: ConnectionStatus = .disconnected
    
    private var messageContinuation: AsyncThrowingStream<String, Error>.Continuation?
    private var connectionStatusContinuation: AsyncStream<ConnectionStatus>.Continuation?
    
    // MARK: Initializer
    init(url: URL = CoreAppConfig.socketURL,
         session: URLSession = .shared) {
        self.url = url
        self.session = session
    }
}

// MARK: Connect/Disconnect
extension WebSocketClient {
    func connect() {
        guard socketTask == nil else { return }
        socketTask = session.webSocketTask(with: url)
        socketTask?.resume()
        latestConnectionStatus = .connected
        connectionStatusContinuation?.yield(.connected)
        receiveMessage()
    }
    
    func disconnect() {
        socketTask?.cancel(with: .goingAway,
                           reason: nil)
        socketTask = nil
        updateConnectionStatus(.disconnected)
        finishStreams()
    }
    
    func send(_ text: String) async throws {
        guard let socketTask else {
            throw WebSocketError.notConnected
        }
        try await socketTask.send(.string(text))
    }
}

// MARK: Stream Message and Connection Status
extension WebSocketClient {
    func messageStream() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            self.messageContinuation = continuation
        }
    }
    
    func connectionStream() -> AsyncStream<ConnectionStatus> {
        AsyncStream { continuation in
            self.connectionStatusContinuation = continuation
            self.connectionStatusContinuation?.yield(latestConnectionStatus)
        }
    }
}

// MARK: Receive Messages
extension WebSocketClient {
    private func receiveMessage() {
        socketTask?.receive { [weak self] result in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let message):
                weakSelf.handleMessage(message)
                weakSelf.receiveMessage()
            case .failure(let error):
                weakSelf.handleFailure(error)
            }
        }
    }
}

// MARK: Private Methods
private extension WebSocketClient {
    func updateConnectionStatus(_ status: ConnectionStatus) {
        latestConnectionStatus = status
        connectionStatusContinuation?.yield(status)
    }
    
    func finishStreams() {
        messageContinuation?.finish()
        connectionStatusContinuation?.finish()
        messageContinuation = nil
        connectionStatusContinuation = nil
    }
    
    func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            messageContinuation?.yield(text)
        default:
            break
        }
    }

    func handleFailure(_ error: Error) {
        updateConnectionStatus(.failed(.unknown(error.localizedDescription)))
        messageContinuation?.finish(throwing: error)
    }
}
