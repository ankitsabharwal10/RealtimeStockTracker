//
//  StocksListView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct StocksListView: View {
//    // MARK: - Properties
    @StateObject
    var viewModel: StocksListViewModel
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.stocks.isEmpty {
                    EmptyStateView()
                } else {
                    stocksList
                }
            }
            .navigationTitle(
                "Real-Time Stocks"
            )
        }
    }
}

// MARK: Top Section to Show connection status and change connection
private extension StocksListView {
    var topSection: some View {
        HStack {
            ConnectionStatusView(
                status: viewModel.connectionStatus
            )

            Spacer()

            Button {
                viewModel.toggleConnection()
            } label: {
                Text(
                    viewModel.connectionStatus
                    == .connected
                    ? viewModel.stopFeedTitle
                    : viewModel.startFeedTitle
                )
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Sorting Section
private extension StocksListView {
    var sortingSection: some View {
        Picker("",
               selection: $viewModel.sortOption)
        {
            Text(SortOption.price.title)
                .tag(SortOption.price)
            Text(SortOption.priceChange.title)
                .tag(SortOption.priceChange)
        }
        .pickerStyle(.segmented)
    }
}

// MARK: Stock List
private extension StocksListView {
    var stocksList: some View {
        VStack(spacing: 16) {
            topSection
            sortingSection
            List(viewModel.stocks) { stock in
                NavigationLink {
                    StockDetailView(
                        stockService: viewModel.stockService,
                        stock: stock
                    )
                } label: {
                    StockRowView(
                        stock: stock
                    )
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StocksListView(viewModel: StocksListViewModel(
        stockService: StockService.preview
    ))
}
