//
//  StockProvider.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

final class StockProvider: StockProviderProvidable {
    func fetchStocks() async throws -> [Stock] {
        return StockSymbol.allStocks
    }
    
    func generateRandomUpdate() -> StockPriceUpdate? {
        guard let randomStock = StockSymbol.allCases.randomElement() else { return nil }
        let randomPrice = Double.random(in: 100...500).rounded()
        return StockPriceUpdate(symbol: randomStock.rawValue, price: randomPrice)
    }
}
