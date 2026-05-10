//
//  StockRowView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct StockRowView: View {
    // MARK: - Properties
    let stock: Stock
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: 16) {
            leftSection
            Spacer()
            rightSection
        }
        .padding(.vertical, 6)
    }
}

private extension StockRowView {
    var leftSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stock.symbol)
                .font(.headline)
            Text(stock.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    var rightSection: some View {
        VStack(alignment: .trailing, spacing: 4) {
            StockPriceView(
                price: stock.formattedCurrentPrice
            )
            PriceChangeView(
                value: stock.priceChange
            )
        }
    }
}

#Preview {
    StockRowView(stock: StockSymbol.allStocks.first!)
}
