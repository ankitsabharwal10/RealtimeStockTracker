//
//  SortOption.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import Foundation

enum SortOption {
    case price
    case priceChange
    
    var title: String {
        switch self {
        case .price:
            return CoreUIStrings.priceOption.localizedText
        case .priceChange:
            return CoreUIStrings.priceChangeOption.localizedText
        }
    }
}
