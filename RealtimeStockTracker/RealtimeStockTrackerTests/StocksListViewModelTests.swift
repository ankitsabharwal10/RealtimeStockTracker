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
    func testInitialState() {
        switch viewModel.viewState {
        case .idle:
            XCTAssertTrue(true)
        default:
            XCTFail("Expected idle state")
        }
    }
    
    func testInitialConnectionStatus() {
        XCTAssertEqual(viewModel.connectionStatus, .disconnected)
    }
    
    func testFetchStock() async throws {
        try await service.fetchStocks()
        
        XCTAssertTrue(!service.stocks.isEmpty)
    }
    
    func testFetchStockSucces() async throws {
        try await service.fetchStocks()
        await Task.yield()

        switch viewModel.viewState {
        case .success(let stocks):
            XCTAssertFalse(stocks.isEmpty)
        default:
            XCTFail("Expected success state")
        }
    }
    
    func testToggleConnectionDisconnectsSocket() {
        viewModel.toggleConnection()
        viewModel.toggleConnection()
        XCTAssertEqual(viewModel.connectionStatus, .disconnected)
    }
    
    func testSortByPrice() async throws {
        try await service.fetchStocks()
        viewModel.sortOption = .price
        switch viewModel.viewState {
        case .success(let stocks):
            let prices = stocks.map { $0.currentPrice }
            XCTAssertEqual(prices,
                           prices.sorted(by: >))
        default:
            XCTFail("Expected success state")
        }
    }
    
    func testSortByPriceChange() async throws {
        try await service.fetchStocks()
        viewModel.sortOption = .priceChange
        switch viewModel.viewState {
        case .success(let stocks):
            let prices = stocks.map { $0.priceChange }
            XCTAssertEqual(prices,
                           prices.sorted(by: >))
        default:
            XCTFail("Expected success state")
        }
    }
}
