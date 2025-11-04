//
//  CoinsViewModel.swift
//  ios-networking
//
//  Created by Natasha Radika on 02/11/25.
//

import Foundation

// Observable Object can publish changes so any other view observing it can automatically update itself when data changes
class CoinsViewModel: ObservableObject {
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    
    init() {
        fetchPrice(coin: "litecoin")
        fetchPrice(coin: "bitcoin")
    }
    
    func fetchPrice(coin: String) {
        print("fetchPrice: \(Thread.current)")
        let urlString = "https://api.coingecko.com/api/v3/simple/price?vs_currencies=usd&ids=\(coin)&names=Bitcoin&symbols=btcn"
        
        // convert it to url object
        // URL is a struct defined in foundation library
        // wrapper for CFURL from core foundation
        // parse the string to structured component kayak scheme (https), host (example.com), path (/path), query (query=1), fragment, port, user, password
        // pastiin stringnya valid as url
        guard let url = URL(string: urlString) else { return }
        
        // URL session
        // - networking api nya apple yg open TCP connection, handle TLS, managing cookies, caching, redirect, retry, background download
        // dataTask
        // - bikin task object yg represent 1 http request/response
        // - buat tau harus manggil url apa, http header, parse response, callback untuk jalanin ketika selesai
        // - cara startnya dengan panggil .resume() karena ga start otomatis
        
        // OSI layer
        // application: URLSession ambil URL dan siapin http request object (kalo https berarti butuh TLS encryption)
        // presentation: pake TLS, di layer ini perform handshake, certificate validation, encryption key negotiation, intinya di layer ini datanya di-encrypt sebelum meninggalkan device
        // session: pastiin socketnya alive, cookies dan session token, redirect or auth
        // transport: pake TCP yang open connection to server IP dan port, split http request ke packet dan pastiin sampe dgn baik
        // network: setiap paket dikasih alamat source sama destination
        // data link and physical: packet diubah jadi frame lalu ke electric/radio signal trs dikirim dari network adapter ke cell tower
        
        // data Task take time to get the data, jadi completion handler itu baru akan execute setelah datanya ready
        URLSession.shared.dataTask(with: url) { data, response, error in
            // pokoknya kalo mau update UI harus di dalem dispatch queue main
            // jadi klo kita panggil function ini 2 kali, itu bakal nungguin sampe 1 kelar baru jalanin yang satunya lagi
            DispatchQueue.main.async {
                if let error = error {
                    print("debug: failed with error \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Bad HTTP response"
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    self.errorMessage = "Failed to fetch with status code \(httpResponse.statusCode)"
                    return
                }
                
                print("DEBUG: response code is \(httpResponse.statusCode)")
                
                print("inside completion handler: \(Thread.current)")
                print("Did receive data \(data)")
                // raw bytes, makanya harus di-decode
                guard let data = data else { return }
                // baca raw data, parse ke json standard, return array n dict
                // transform to dictionary
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("failed to parse json object")
                    return
                }
                print("json \(jsonObject)")
                
                guard let value = jsonObject[coin] as? [String: Double] else {
                    print("failed to parse value")
                    return
                }
                
                print("value: \(value)")
                
                guard let price = value["usd"] else {
                    print("failed to parse price")
                    return
                }
                
                self.coin = coin.capitalized
                self.price = "\(price)"
            }
        }.resume() // klo pake completion handler harus pake resume
        
        
    }
}

