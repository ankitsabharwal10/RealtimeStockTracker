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
            content
                .navigationTitle(viewModel.screenTitle)
        }
    }
}

private extension StocksListView {
    @ViewBuilder
    var content: some View {
        switch viewModel.viewState {
        case .idle, .loading:
            ProgressView()
        case .empty:
            EmptyStateView()
        case .success(let stocks):
            stocksList(stocks)
        case .failure(let errorMessage):
            Text(errorMessage)
        }
    }
}

// MARK: Stock List
private extension StocksListView {
    func stocksList(_ stocks: [Stock]) -> some View {
        VStack(spacing: 16) {
            topSection
            sortingSection
            List(stocks) { stock in
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
                    viewModel.buttonTitle
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

#Preview {
    StocksListView(viewModel: StocksListViewModel(
        stockService: StockService.preview
    ))
}
