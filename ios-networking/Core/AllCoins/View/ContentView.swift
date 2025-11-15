//
//  ContentView.swift
//  ios-networking
//
//  Created by Natasha Radika on 01/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = CoinsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.coins) { coin in
                Text(coin.name)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
