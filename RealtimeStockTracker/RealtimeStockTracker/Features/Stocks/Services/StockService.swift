//
//  StockService.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation
import Combine

@MainActor
final class StockService: ObservableObject {
    // MARK: Published Properties
    @Published
    private(set) var stocks: [Stock] = []
    
    @Published
    private(set) var connectionStatus: ConnectionStatus = .disconnected
    
    // MARK: - Private Properties
    private let stockProvider: StockProviderProvidable
    private let webSocketClient: WebSocketClientProvidable
    private var observerTask: Task<Void, Never>?
    private var serviceTask: Task<Void, Never>?
    
    // MARK: - Initializer
    init(stockProvider: StockProviderProvidable,
         webSocketClient: WebSocketClientProvidable) {
        self.stockProvider = stockProvider
        self.webSocketClient = webSocketClient
    }
    
    func fetchStocks() async throws {
        stocks = try await stockProvider.fetchStocks()
    }
    
    func connect() {
        guard serviceTask == nil,
              observerTask == nil else { return }

        startListeners()
        
        webSocketClient.connect()

        serviceTask = Task {
            await startStreaming()
        }
    }
    
    func disconnect() {
        webSocketClient.disconnect()
        serviceTask?.cancel()
        serviceTask = nil
        observerTask?.cancel()
        observerTask = nil
    }
}

private extension StockService {
    func startListeners() {
        observerTask = Task {
            async let connectionTask: Void = listenConnectionStatus()
            async let messageTask: Void = listenMessages()
            
            _ = await (connectionTask, messageTask)
        }
    }
    
    func startStreaming() async {
        while !Task.isCancelled {
            guard let update = stockProvider.generateRandomUpdate(),
                  let jsonString = update.toJSONString else { continue }
            do {
                try await webSocketClient.send(jsonString)
            } catch {
                debugPrint(error)
            }
            try? await Task.sleep(for: .seconds(1))
        }
    }
    
    func listenConnectionStatus() async {
        for await status in webSocketClient.connectionStream() {
            connectionStatus = status
        }
    }
    
    func listenMessages() async {
        do {
            for try await message in webSocketClient.messageStream() {
                guard let update = message.decode(StockPriceUpdate.self) else {
                    debugPrint("Unable to decode 'StockPriceUpdate'")
                    continue
                }
                apply(update)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func apply(_ update: StockPriceUpdate) {
        guard let index = stocks.firstIndex(where: { $0.symbol == update.symbol }) else { return }
        var updatedStock = stocks[index]
        updatedStock.previousPrice = stocks[index].currentPrice
        updatedStock.currentPrice = update.price
        stocks[index] = updatedStock
        debugPrint(updatedStock)
    }
}

extension StockService {
    static var preview: StockService {
        let service = StockService(
            stockProvider: StockProvider(),
            webSocketClient: MockWebSocketClient()
        )
        service.stocks = StockSymbol.allStocks
        return service
    }
}
