//
//  Coin.swift
//  ios-networking
//
//  Created by Natasha Radika on 12/11/25.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}
