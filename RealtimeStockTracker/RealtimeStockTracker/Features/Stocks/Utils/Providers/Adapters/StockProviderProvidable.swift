//
//  StockProviderProvidable.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

protocol StockProviderProvidable {
    func fetchStocks() async throws -> [Stock]
    func generateRandomUpdate() -> StockPriceUpdate?
}
