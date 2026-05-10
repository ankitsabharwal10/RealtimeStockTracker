//
//  String+Core.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

extension String {
    static func localizeString(forKey key: String,
                               fileName: String,
                               bundle: Bundle = Bundle.main) -> String {
        return NSLocalizedString(key, tableName: fileName, bundle: bundle, comment: key)
    }
    
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
