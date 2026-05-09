//
//  ConnectionStatus.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum ConnectionStatus {
    case connected
    case disconnected
    case failed(Error)
}
