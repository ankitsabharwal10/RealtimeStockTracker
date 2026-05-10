//
//  Stock.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

struct Stock: Identifiable {
    let id: String
    let symbol: String
    let name: String
    let description: String
    var currentPrice: Double
    var previousPrice: Double
    
    var priceChange: Double {
        currentPrice - previousPrice
    }
    var isPositive: Bool {
        priceChange >= 0
    }
}
