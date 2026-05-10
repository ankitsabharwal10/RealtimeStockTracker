//
//  StockPriceView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct StockPriceView: View {
    
    // MARK: - Properties
    let price: String
    
    // MARK: - Body
    
    var body: some View {
        Text(price)
        .font(.caption.weight(.bold))
    }
}

#Preview {
    StockPriceView(price: "100")
}
