//
//  ChartView.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//

import SwiftUI

struct ChartView: View {
    
    let data:[Double]
    init(data: CoinModel) {
        data = coin
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ChartView()
}
