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
        VStack {
            if let error = viewModel.errorMessage  {
                Text("\(error)")
            } else {
                Text("\(viewModel.coin): \(viewModel.price)")
            }
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
