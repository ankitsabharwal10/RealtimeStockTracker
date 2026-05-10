//
//  StockServiceTests.swift
//  RealtimeStockTrackerTests
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import XCTest
@testable import RealtimeStockTracker
internal import Combine

@MainActor
final class StockServiceTests: XCTestCase {
    // MARK: Properties
    private var provider: StockProvider!
    private var socket: MockWebSocketClient!
    private var service: StockService!
    
    // MARK: Setup
    override func setUp() {
        provider = StockProvider()
        socket = MockWebSocketClient()
        
        service = StockService(stockProvider: provider,
                               webSocketClient: socket)
    }

    override func tearDown() {
        provider = nil
        socket = nil
        service = nil
        
        super.tearDown()
    }
}

// MARK: Tests
extension StockServiceTests {
    func testInitialStockEmpty() {
        XCTAssertTrue(service.stocks.isEmpty)
    }
    
    func testInitialConnectionStatus() {
        XCTAssertEqual(service.connectionStatus, .disconnected)
    }
    
    func testFetchStock() async throws {
        try await service.fetchStocks()
        
        XCTAssertTrue(!service.stocks.isEmpty)
    }
    
    func testConnectionStatusConnectUpdates() async {
        let expectation = XCTestExpectation(description: "Connected")
        let task = Task {
            for await status in service.$connectionStatus.values {
                if status == .connected {
                    expectation.fulfill()
                    break
                }
            }
        }
        
        service.connect()
        
        await fulfillment(of: [expectation])
        task.cancel()
    }
    
    func testConnectionStatusDisconnectUpdates() async {
        let expectation = XCTestExpectation(description: "Disconnected")
        let task = Task {
            for await status in service.$connectionStatus.values {
                if status == .disconnected {
                    expectation.fulfill()
                    break
                }
            }
        }
        
        service.connect()
        service.disconnect()
        
        await fulfillment(of: [expectation])
        task.cancel()
    }
    
    func testStockPriceUpdates() async throws {
        try await service.fetchStocks()
                
        service.connect() // Establishing the connection

        await Task.yield()
        guard let stock = service.stocks.first else {
            XCTFail("Missing Stock")
            return
        }
        
        let updatedPrice = stock.currentPrice + 10.0
        let update = StockPriceUpdate(symbol: stock.symbol,
                                            price: updatedPrice)
        guard let json = update.toJSONString else {
            XCTFail("Unable to Convert Json")
            return
        }
            
        try await socket.send(json)
        
        try await Task.sleep(
            for: .milliseconds(100)
        )
        
        let updatedStock = service.stocks
            .first {
                $0.symbol == stock.symbol
            }
        
        XCTAssertEqual(
            updatedStock?.currentPrice,
            updatedPrice
        )
    }
}
