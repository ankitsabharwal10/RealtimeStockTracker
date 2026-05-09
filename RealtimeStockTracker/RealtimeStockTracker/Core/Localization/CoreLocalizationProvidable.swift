//
//  CoreLocalizationProvidable.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

protocol CoreLocalizationProvidable {
    var localizeFileName: String { get }
    var localizeKeyName: String { get }
}

extension CoreLocalizationProvidable {
    var localizedText: String {
        String.localizeString(forKey: localizeKeyName, fileName: localizeFileName)
    }
}
