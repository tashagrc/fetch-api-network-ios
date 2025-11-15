//
//  CoinsViewModel.swift
//  ios-networking
//
//  Created by Natasha Radika on 02/11/25.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    
    private let service = CoinDataService()
    
    init() {
        // fetchPrice(coin: "bitcoin")
        fetchCoins()
    }
    
    func fetchCoins() {
        service.fetchCoins { coins in
            DispatchQueue.main.async {
                self.coins = coins
            }
        }
    }
    
//    func fetchPrice(coin: String) {
//        service.fetchPrice(coin: coin) { priceFromService in
//            DispatchQueue.main.async {
//                self.price = "$\(priceFromService)"
//                self.coin = coin
//            }
//        }
//    }
}

