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
//    let currentPrice: Double
//    let marketCapRank: Int
}
