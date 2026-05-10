//
//  ConnectionStatus.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum ConnectionStatus: Equatable {
    case connected
    case disconnected
    case failed(WebSocketError)
}
