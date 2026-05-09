//
//  AppConfig.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum CoreAppConfig {
    static var socketURL: URL {
        var components = URLComponents()
        components.scheme = value(for: CoreAppConfigKeys.socketScheme)
        components.host = value(for: CoreAppConfigKeys.socketHost)
        components.path = value(for: CoreAppConfigKeys.socketPath)
        
        guard let url = components.url else {
            fatalError("Invalid Socket URL")
        }
        
        return url
    }
}

private extension CoreAppConfig {
    static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("Missing Config key : \(key)")
        }
        return value
    }
}
