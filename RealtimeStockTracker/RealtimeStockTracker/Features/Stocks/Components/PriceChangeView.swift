//
//  PriceChangeView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct PriceChangeView: View {
    
    // MARK: - Properties
    let value: Double

    // MARK: - Body
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: value >= 0 ? "arrow.up.right" : "arrow.down.right")
            Text(value.formatted(.number
                .precision(.fractionLength(2))))
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(value >= 0 ? .green : .red)
    }
}

#Preview {
    PriceChangeView(value: -3)
}
