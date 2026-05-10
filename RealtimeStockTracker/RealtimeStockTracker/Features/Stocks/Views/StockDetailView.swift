//
//  StockDetailView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct StockDetailView: View {
    @ObservedObject var stockService: StockService
    let stock: Stock
    
    var body: some View {
        Group {
            VStack(spacing: 16) {
                Text(stock.symbol)
                    .font(.largeTitle)
                Text(stock.name)
                    .font(.title3)
                Text(stock.formattedCurrentPrice)
                    .font(.system(size: 40,
                                  weight: .bold))
                Text(stock.priceChangeStr)
                    .foregroundStyle( stock.priceChange >= 0 ? .green : .red)
            }
        }
        .padding()
        .navigationTitle(CoreUIStrings.stockDetailsTitle.localizedText)
    }
}

#Preview {
    NavigationStack {
        StockDetailView(stockService: StockService.preview,
                        stock: StockSymbol.defaultStock)
    }
}
