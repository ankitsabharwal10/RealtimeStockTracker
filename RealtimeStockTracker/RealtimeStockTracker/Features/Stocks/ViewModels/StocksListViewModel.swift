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
    @Published private(set) var viewState: ViewState<[Stock]> = .idle
    @Published private(set) var connectionStatus: ConnectionStatus = .disconnected
    @Published var sortOption: SortOption = .price {
        didSet {
            applySorting()
        }
    }
    
    // MARK: Properties
    private var observationTask: Task<Void, Never>?
    var stockService: StockService
    
    // MARK: Computed Properties
    var screenTitle: String {
        return CoreUIStrings.stocksTitle.localizedText
    }
    var buttonTitle: String {
        connectionStatus == .connected ? CoreUIStrings.stopFeed.localizedText : CoreUIStrings.startFeed.localizedText
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
        case .disconnected, .failed:
            stockService.connect()
        }
    }
    
    deinit {
        observationTask?.cancel()
    }
}

private extension StocksListViewModel {
    func fetchStocks() {
        Task {
            viewState = .loading
    
            do {
                try await stockService.fetchStocks()
                updateStocks(stockService.stocks)
            } catch {
                viewState = .failure(error.localizedDescription)
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
            updateStocks(updatedStocks)
        }
    }
    
    func listenConnection() async {
        for await status in stockService.$connectionStatus.values {
            connectionStatus = status
        }
    }
    
    func applySorting() {
        updateStocks(stockService.stocks)
    }
    
    func sortedStocks(from stocks: [Stock]) -> [Stock] {
        switch sortOption {
        case .price:
            return stocks.sorted { $0.currentPrice > $1.currentPrice }
        case .priceChange:
            return stocks.sorted { $0.priceChange > $1.priceChange }
        }
    }
    
    func updateStocks(_ stocks: [Stock]) {
        let sortedStocks = sortedStocks(from: stocks)
        viewState = sortedStocks.isEmpty ? .empty : .success(sortedStocks)
    }
}
