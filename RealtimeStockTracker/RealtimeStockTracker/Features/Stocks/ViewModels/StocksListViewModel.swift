//
//  StocksListViewModel.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import Combine
import Foundation

@MainActor
final class StocksListViewModel: ObservableObject {
    
    // MARK: Published Properties
    @Published var stocks: [Stock] = []
    @Published var isLoading: Bool = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var sortOption: SortOption = .price {
        didSet {
            applySorting()
        }
    }
    
    // MARK: Properties
    private var observationTask: Task<Void, Never>?
    var stockService: StockService
    var startFeedTitle: String {
        return CoreUIStrings.startFeed.localizedText
    }
    var stopFeedTitle: String {
        return CoreUIStrings.stopFeed.localizedText
    }

    init(stockService: StockService) {
        self.stockService = stockService
        fetchStocks()
        setupObservers()
    }
    
    // MARK: Methods
    func toggleConnection() {
        switch stockService.connectionStatus {
        case .connected:
            stockService.disconnect()
        case .disconnected:
            stockService.connect()
        case .failed(let error):
            debugPrint(error)
        }
    }
    
    deinit {
        observationTask?.cancel()
    }
}

private extension StocksListViewModel {
    func fetchStocks() {
        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            do {
                try await stockService.fetchStocks()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func setupObservers() {
        observationTask = Task {
            async let stockListening: Void = listenStocks()
            async let connectionListening: Void = listenConnection()
            
            let _ = await (stockListening, connectionListening)
        }
    }
    
    func listenStocks() async {
        for await updatedStocks in stockService.$stocks.values {
            stocks = sortedStocks(from: updatedStocks)
        }
    }
    
    func listenConnection() async {
        for await status in stockService.$connectionStatus.values {
            connectionStatus = status
        }
    }
    
    func applySorting() {
        stocks = sortedStocks(from: stockService.stocks)
    }
    
    func sortedStocks(from stocks: [Stock]) -> [Stock] {
        switch sortOption {
        case .price:
            return stocks.sorted { $0.currentPrice > $1.currentPrice }
        case .priceChange:
            return stocks.sorted { $0.priceChange > $1.priceChange }
        }
    }
}
