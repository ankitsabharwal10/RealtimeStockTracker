//
//  MockWebSocketClient.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

final class MockWebSocketClient: WebSocketClientProvidable {
    // MARK: Private Properties
    private var messageContinuation: AsyncThrowingStream<String, Error>.Continuation?
    private var connectionStatusContinuation: AsyncStream<ConnectionStatus>.Continuation?
    private var latestConnectionStatus: ConnectionStatus = .disconnected

    func connect() {
        latestConnectionStatus = .connected
        connectionStatusContinuation?.yield(.connected)
    }
    
    func disconnect() {
        latestConnectionStatus = .disconnected
        connectionStatusContinuation?.yield(.disconnected)
        messageContinuation?.finish()
        connectionStatusContinuation?.finish()
        messageContinuation = nil
        connectionStatusContinuation = nil
    }
    
    func send(_ text: String) async throws {
        messageContinuation?.yield(text)
    }
    
    func messageStream() -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            messageContinuation = continuation
        }
    }
    
    func connectionStream() -> AsyncStream<ConnectionStatus> {
        AsyncStream { continuation in
            connectionStatusContinuation = continuation
            connectionStatusContinuation?.yield(latestConnectionStatus)
        }
    }
}
