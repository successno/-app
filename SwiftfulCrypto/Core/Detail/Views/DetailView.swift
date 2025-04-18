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
    
    @StateObject private var vm:DetailViewModel
    private let columns: [GridItem] = [
        GridItem(.flexible() ),
        GridItem(.flexible() ),
    ]
    
    private let spacing:CGFloat = 30
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print("chushihua\(coin.name)")
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 20.0){
                Text("")
                    .frame(height: 150)
                
                overviewTitle
                Divider()
                overviewGrid
                
                additionalTitle
                Divider()
                additionalGrid
                
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
    }
}

#Preview {
    NavigationView {
        DetailView(coin:DeveloperPreview.instance.coin)
    }
}

extension DetailView {
    
    private var overviewTitle: some View{
        Text("概述")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var additionalTitle:some View{
        Text("附加详细")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity,alignment: .leading)
    }
    
    private var overviewGrid:some View{
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalGrid:some View{
        LazyVGrid(
            columns: columns,
            alignment: .center,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
}
