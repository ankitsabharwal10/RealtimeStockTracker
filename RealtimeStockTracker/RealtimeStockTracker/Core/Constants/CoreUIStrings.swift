//
//  CoreUIStrings.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum CoreUIStrings: String {
    case stocksTitle = "StocksTitle"
}

extension CoreUIStrings: CoreLocalizationProvidable {
    var localizeFileName: String {
        return CoreConstants.localizeFileName
    }
    
    var localizeKeyName: String {
        return rawValue
    }
}
