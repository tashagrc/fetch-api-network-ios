//
//  CoinsViewModel.swift
//  ios-networking
//
//  Created by Natasha Radika on 02/11/25.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service = CoinDataService()
    
    init() {
        Task {
            try await fetchCoins()
        }
    }
    
    func fetchCoins() async throws {
        let coins = try await service.fetchCoinsAsync()
        await MainActor.run {
            self.coins = coins
        }
    }
    
    // func fetchCoins() {
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                self.coins = coins ?? []
//            }
//        }
//        service.fetchCoins { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let coins):
//                    self?.coins = coins
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
//        }
    // }
    
//    func fetchPrice(coin: String) {
//        service.fetchPrice(coin: coin) { priceFromService in
//            DispatchQueue.main.async {
//                self.price = "$\(priceFromService)"
//                self.coin = coin
//            }
//        }
//    }
}

