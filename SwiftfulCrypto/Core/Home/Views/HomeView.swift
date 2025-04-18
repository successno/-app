//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm :HomeViewModel
    
    @State private var showPortfolio:Bool = false // 动画右侧
    
    @State private var showPortfolioView:Bool = false // 新的工作表  new sheet
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
         ZStack{
            //背景层
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                    //新表相当于新环境，需要重新从环境中获取
                    .environmentObject(vm)
                    
                }
             
            //内容层
            VStack{
               homeHeader
                
                HomeStatsView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columTitle
                
                if !showPortfolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio{
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                
                Spacer(minLength: 0)
            }
        }
         .background(
            NavigationLink(
                destination: DetailLoadingView(coin:$selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() })
         )
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
    .environmentObject(DeveloperPreview.instance.homeVm)
 
}


//添加扩展
extension HomeView{
    
    private var homeHeader: some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                        
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio":"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none,value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
            //旋转
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
            //触摸手势进行切换状态，使用动画过度切换动画
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View{
        List{
            ForEach(vm.allCoins){
                coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View{
        List{
            ForEach(vm.portfolioCoins){
                coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
            
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin:CoinModel){
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columTitle: some View{
        HStack{
            HStack(spacing: 4.0){
                Text("Coin")
                Image(systemName:"chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees:  vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank

                }
            }
            
            Spacer()
            if showPortfolio{
                HStack(spacing: 4.0){
                    Text("Holding")
                    Image(systemName:"chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0 )
                        .rotationEffect(Angle(degrees:  vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                        
                    }
                }
            }
            
            HStack(spacing: 4.0){
                Text("Price")
                Image(systemName:"chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees:  vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5,alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                    
                }
            }
            
            Button(action: {
                withAnimation(.linear(duration: 2.0)){
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isloading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
}
