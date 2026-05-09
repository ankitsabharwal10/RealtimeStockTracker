//
//  ContentView.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 08/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            // TODO: Need to Remove
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(CoreUIStrings.stocksTitle.localizedText)
            Text(CoreAppConfig.socketURL.absoluteString)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
