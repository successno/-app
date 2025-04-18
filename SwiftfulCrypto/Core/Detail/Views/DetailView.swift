//
//  DetailView.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//

import SwiftUI

struct DetailLoadingView:View {
    @Binding var coin: CoinModel?
    var body: some View {
        ZStack{
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
        
    }
}

struct DetailView: View {
    
   let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        print("chushihua\(coin.name)")
    }
    
    var body: some View {
        Text(coin.name)
    }
}

#Preview {
    DetailView(coin:DeveloperPreview.instance.coin)
}
