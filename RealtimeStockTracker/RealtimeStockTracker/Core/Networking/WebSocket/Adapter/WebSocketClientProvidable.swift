//
//  WebSocketClientProvidable.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

protocol WebSocketClientProvidable {
    func connect()
    func disconnect()
    func send(_ text: String) async throws
    
    func messageStream() -> AsyncThrowingStream<String, Error>
    func connectionStream() -> AsyncStream<ConnectionStatus>
}
