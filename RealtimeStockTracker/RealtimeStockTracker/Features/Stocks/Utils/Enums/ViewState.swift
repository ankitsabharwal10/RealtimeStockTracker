//
//  ViewState.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 11/05/26.
//

import Foundation

enum ViewState<T: Equatable>: Equatable {
    case idle
    case loading
    case success(T)
    case empty
    case failure(String)
}
