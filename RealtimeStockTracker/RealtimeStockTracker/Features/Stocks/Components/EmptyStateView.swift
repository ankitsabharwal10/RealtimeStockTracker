//
//  EmptyStateView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.slash")
                .font(.largeTitle)
            Text("No Live Data")
            Text("Tap Start Feed")
                .font(.caption)
        }
        .foregroundStyle(.secondary)
    }
}

#Preview {
    EmptyStateView()
}
