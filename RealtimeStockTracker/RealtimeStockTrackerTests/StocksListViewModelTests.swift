//
//  StocksListViewModelTests.swift
//  RealtimeStockTrackerTests
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import XCTest
@testable import RealtimeStockTracker
internal import Combine

@MainActor
final class StocksListViewModelTests: XCTestCase {
    // MARK: Properties
    private var provider: StockProvider!
    private var socket: MockWebSocketClient!
    private var service: StockService!
    private var viewModel: StocksListViewModel!

    // MARK: Setup
    override func setUp() {
        provider = StockProvider()
        socket = MockWebSocketClient()
        
        service = StockService(stockProvider: provider,
                               webSocketClient: socket)
        
        viewModel = StocksListViewModel(stockService: service)
    }

    override func tearDown() {
        provider = nil
        socket = nil
        service = nil
        viewModel = nil
        
        super.tearDown()
    }
}

// MARK: Tests
extension StocksListViewModelTests {
    func testInitialStockEmpty() {
        XCTAssertTrue(viewModel.stocks.isEmpty)
    }
    
    func testInitialConnectionStatus() {
        XCTAssertEqual(viewModel.connectionStatus, .disconnected)
    }
    
    func testFetchStock() async throws {
        try await service.fetchStocks()
        
        XCTAssertTrue(!service.stocks.isEmpty)
    }
    
    func testSortByPrice() async throws {
        try await service.fetchStocks()
        viewModel.sortOption = .price
        let prices = viewModel.stocks.map({ $0.currentPrice })
        XCTAssertEqual(prices,
                       prices.sorted(by: >))
    }
    
    func testSortByPriceChange() async throws {
        try await service.fetchStocks()
        viewModel.sortOption = .priceChange
        let changes = viewModel.stocks.map({ $0.priceChange })
        
        XCTAssertEqual(changes,
                       changes.sorted(by: >))
    }
}
