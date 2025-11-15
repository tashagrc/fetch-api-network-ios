//
//  CoinDataService.swift
//  ios-networking
//
//  Created by Natasha Radika on 04/11/25.
//

import Foundation

class CoinDataService {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin&names=Bitcoin&symbols=btc&category=layer-1&price_change_percentage=1h"
    
    func fetchCoinsAsync() async throws -> [Coin] {
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("DEBUG error \(error.localizedDescription)")
            return []
        }
    }
}

extension CoinDataService {
    
    func fetchCoins(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "HTTP response error")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else { return }

            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                print("debug failed to decode with error \(error)")
                completion(.failure(.jsonParsingFailure))
            }
        }.resume()
    }
    
//    func fetchCoins(completion: @escaping([Coin]?, Error?) -> Void) {
//        guard let url = URL(string: urlString) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(nil, error)
//                return
//            }
//            guard let data = data else { return }
//
//            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else { return }
//            completion(coins, nil)
//        }.resume()
//    }
    
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        print("fetchPrice: \(Thread.current)")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?vs_currencies=usd&ids=\(coin)&names=Bitcoin&symbols=btcn"
    
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("debug: failed with error \(error.localizedDescription)")
                // self.errorMessage = error.localizedDescription
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // self.errorMessage = "Bad HTTP response"
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                // self.errorMessage = "Failed to fetch with status code \(httpResponse.statusCode)"
                return
            }
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("failed to parse json object")
                return
            }
            
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("failed to parse value")
                return
            }
            
            print("value: \(value)")
            
            guard let price = value["usd"] else {
                print("failed to parse price")
                return
            }
            
            completion(price)
        }.resume()
    }
}
