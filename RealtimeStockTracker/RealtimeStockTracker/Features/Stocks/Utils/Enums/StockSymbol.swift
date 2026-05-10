//
//  StockSymbol.swift
//  RealtimeStockTracker
//
//  Created by Ankit Sabharwal on 09/05/26.
//

import Foundation

enum StockSymbol: String, CaseIterable {
    case aapl = "AAPL"
    case tsla = "TSLA"
    case goog = "GOOG"
    case msft = "MSFT"
    case nvda = "NVDA"
    case amzn = "AMZN"
    case meta = "META"
    case nflx = "NFLX"
    case amd = "AMD"
    case intel = "INTC"
    case uber = "UBER"
    case snap = "SNAP"
    case pypl = "PYPL"
    case baba = "BABA"
    case orcl = "ORCL"
    case crm = "CRM"
    case shop = "SHOP"
    case adbe = "ADBE"
    case sony = "SONY"
    case tsm = "TSM"
    case qcom = "QCOM"
    case arm = "ARM"
    case spotify = "SPOT"
    case zoom = "ZM"
    case airbnb = "ABNB"
    
    static var allStocks: [Stock] {
        allCases.map {
            Stock(id: $0.rawValue,
                  symbol: $0.rawValue,
                  name: $0.companyName,
                  description: $0.description,
                  currentPrice: $0.initialPrice,
                  previousPrice: $0.initialPrice)
        }
    }
    
    static var defaultStock: Stock {
        Stock(id: airbnb.rawValue,
              symbol: airbnb.rawValue,
              name: airbnb.companyName,
              description: airbnb.description,
              currentPrice: airbnb.initialPrice,
              previousPrice: airbnb.initialPrice)
    }
}

// MARK: Company Name
extension StockSymbol {
    var companyName: String {
        switch self {
        case .aapl:
            return "Apple Inc."
        case .tsla:
            return "Tesla Inc."
        case .goog:
            return "Alphabet Inc."
        case .msft:
            return "Microsoft"
        case .nvda:
            return "NVIDIA"
        case .amzn:
            return "Amazon"
        case .meta:
            return "Meta"
        case .nflx:
            return "Netflix"
        case .amd:
            return "AMD"
        case .intel:
            return "Intel"
        case .uber:
            return "Uber"
        case .snap:
            return "Snap"
        case .pypl:
            return "PayPal"
        case .baba:
            return "Alibaba"
        case .orcl:
            return "Oracle"
        case .crm:
            return "Salesforce"
        case .shop:
            return "Shopify"
        case .adbe:
            return "Adobe"
        case .sony:
            return "Sony"
        case .tsm:
            return "TSMC"
        case .qcom:
            return "Qualcomm"
        case .arm:
            return "ARM Holdings"
        case .spotify:
            return "Spotify"
        case .zoom:
            return "Zoom"
        case .airbnb:
            return "Airbnb"
        }
    }
}

// MARK: Company Description
extension StockSymbol {
    var description: String {
        switch self {
        case .aapl:
            return "Consumer electronics company."
        case .tsla:
            return "Electric vehicle manufacturer."
        case .goog:
            return "Search and cloud company."
        case .msft:
            return "Software and cloud company."
        case .nvda:
            return "AI and graphics company."
        case .amzn:
            return "E-commerce platform."
        case .meta:
            return "Social media company."
        case .nflx:
            return "Streaming platform."
        case .amd:
            return "Semiconductor company."
        case .intel:
            return "Chip manufacturer."
        case .uber:
            return "Ride sharing platform."
        case .snap:
            return "Social media app."
        case .pypl:
            return "Digital payment company."
        case .baba:
            return "Chinese e-commerce company."
        case .orcl:
            return "Enterprise software company."
        case .crm:
            return "CRM platform company."
        case .shop:
            return "E-commerce infrastructure company."
        case .adbe:
            return "Creative software company."
        case .sony:
            return "Electronics and entertainment company."
        case .tsm:
            return "Semiconductor manufacturing company."
        case .qcom:
            return "Wireless technology company."
        case .arm:
            return "CPU architecture company."
        case .spotify:
            return "Music streaming platform."
        case .zoom:
            return "Video conferencing platform."
        case .airbnb:
            return "Hospitality marketplace."
        }
    }
}

// MARK: Initail Price
extension StockSymbol {
    var initialPrice: Double {
        switch self {
        case .aapl:
            return 180
        case .tsla:
            return 240
        case .goog:
            return 150
        case .msft:
            return 320
        case .nvda:
            return 900
        case .amzn:
            return 170
        case .meta:
            return 450
        case .nflx:
            return 620
        case .amd:
            return 165
        case .intel:
            return 38
        case .uber:
            return 75
        case .snap:
            return 14
        case .pypl:
            return 65
        case .baba:
            return 85
        case .orcl:
            return 130
        case .crm:
            return 290
        case .shop:
            return 78
        case .adbe:
            return 520
        case .sony:
            return 95
        case .tsm:
            return 145
        case .qcom:
            return 170
        case .arm:
            return 125
        case .spotify:
            return 310
        case .zoom:
            return 68
        case .airbnb:
            return 155
        }
    }
}
