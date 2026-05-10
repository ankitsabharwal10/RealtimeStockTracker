//
//  WebSocketError.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum WebSocketError: Error, Equatable {
    case notConnected
    case unknown(String)
}
