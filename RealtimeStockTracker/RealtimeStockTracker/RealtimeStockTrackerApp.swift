//
//  RealtimeStockTrackerApp.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 08/05/26.
//

import SwiftUI

@main
struct RealtimeStockTrackerApp: App {
    // MARK: Properties
    @StateObject private var stockService = StockService(stockProvider: StockProvider(),
                                                         webSocketClient: MockWebSocketClient())
    
    var body: some Scene {
        WindowGroup {
            StocksListView(viewModel: StocksListViewModel(stockService: stockService))
        }
    }
}
