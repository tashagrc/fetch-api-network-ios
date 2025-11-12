//
//  CoinDataService.swift
//  ios-networking
//
//  Created by Natasha Radika on 04/11/25.
//

import Foundation

class CoinDataService {
    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        print("fetchPrice: \(Thread.current)")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?vs_currencies=usd&ids=\(coin)&names=Bitcoin&symbols=btcn"
    
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
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
                
               //  self.coin = coin.capitalized
                // self.price = "\(price)"
            }
        }.resume()
    }
}
