//
//  ConnectionStatusView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 10/05/26.
//

import SwiftUI

struct ConnectionStatusView: View {
    
    // MARK: - Properties
    let status: ConnectionStatus
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(status == .connected ? .green : .red).frame(width: 10)
            Text(
                status == .connected ? "Connected" : "Disconnected"
            )
            .font(.system(size: 18))
        }
    }
}

#Preview {
    ConnectionStatusView(status: .connected)
}
