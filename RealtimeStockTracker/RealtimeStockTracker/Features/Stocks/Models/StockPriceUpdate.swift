//
//  StockPriceUpdate.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

struct StockPriceUpdate: Codable {
    let symbol: String
    let price: Double
}
