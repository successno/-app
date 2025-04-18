//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/17.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm:HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckmark:Bool = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogeList
                    
                    if selectedCoin != nil{
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("编辑投资组合")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNaviBarButtons
                }
            })
            .onChange(of: vm.searchText) { oldValue, newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
           // .navigationBarItems( leading:XmarkButton() )  ios14弃用改为toolbar(content:)
        }
    }
}

#Preview {
    PortfolioView()
        .environmentObject(DeveloperPreview.instance.homeVm)
}

extension PortfolioView{
    private var coinLogeList:some View{
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins){ coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectedCoin = coin
                            }
                        }
                        .background (
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green :Color.clear, lineWidth: 1)
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin:CoinModel){
        selectedCoin = coin
        
      if let porfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
         let amount = porfolioCoin.currentHoldings {
          quantityText = "\(amount)"
      }else{
          quantityText = ""
      }
    }
    
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private var portfolioInputSection:some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of\(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            Divider()//分隔符
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex:1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none,value: quantityText)
        .padding()
        .font(.headline)
    }
    
    private var trailingNaviBarButtons:some View{
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1.0 : 0.0 )
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("Save".uppercased())
            })
            
            .opacity(
                (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0 )
        }
        .font(.headline)
    }
    
    
    
    private func saveButtonPressed() {
        guard
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            print("Before showing checkmark, showCheckmark value: \(showCheckmark)")
            showCheckmark = true
            print("After showing checkmark, showCheckmark value: \(showCheckmark)")
            removeSelectedCoin()
        }
        
        //键盘取消
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                print("Before hiding checkmark, showCheckmark value: \(showCheckmark)")
                showCheckmark = false
                print("After hiding checkmark, showCheckmark value: \(showCheckmark)")
                print("关闭窗口")
            }
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
 
    
    
}

