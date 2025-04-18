//
//  HomeViewModel.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/8.
//

import Foundation
import Combine

class HomeViewModel:ObservableObject {
    @Published var statistics : [StatisticModel] = []
    @Published var allCoins:[CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText:String = ""
    @Published var isloading:Bool = false
    @Published var sortOption:SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    
    private let marketDataService = MarketDataService()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let portfolioDataService = PortfolioDataService()
    
    init(){
        addSubscribers()
    }
    
    enum SortOption {
        case rank , rankReversed,holdings,holdingsReversed,price,priceReversed
    }
    
    //更新所有货币
    func addSubscribers(){
        
        //在下面搜索文本已经订阅了，这里注释掉了
        //        dataService.$allCoins
        //            .sink { [weak self] (returnCoins) in
        //                self?.allCoins = returnCoins
        //            }
        //            .store(in: &cancellables)
        
        //订阅搜索文本的所有货币
        
        $searchText
            .combineLatest(coinDataService.$allCoins,$sortOption)
        //.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) 是响应式编程里的一个操作符，常用于处理异步事件流，避免短时间内频繁触发某些操作。
        //for: .seconds(0.5)：指定了一个时间间隔，这里是 0.5 秒。意味着在接收到一个事件后，debounce 操作符会等待 0.5 秒，如果在这 0.5 秒内没有新的事件到来，就会将这个事件发送出去；如果在这 0.5 秒内又有新的事件产生，那么之前的事件就会被忽略，重新开始计时。
        //scheduler: DispatchQueue.main：指定了事件最终发送的调度队列，这里是主队列 DispatchQueue.main。主队列用于处理 UI 相关的操作，确保事件在主线程中执行，避免出现 UI 更新异常的问题
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSordCoins)
        //函数封装
        //            .map { (text, startingCoins) -> [CoinModel] in
        //
        //                guard !text.isEmpty else{
        //                    return startingCoins
        //                }
        //                //将所有内容过滤为小写
        //                let lowercasedText = text.lowercased()
        //
        //               return startingCoins.filter { (coin) -> Bool in
        //                   return coin.name.lowercased().contains(lowercasedText) ||
        //                   coin.symbol.lowercased().contains(lowercasedText) ||
        //                   coin.id.lowercased().contains(lowercasedText)
        //               }
        //         }
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // 更新投资组合硬币的订阅者
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        //更新 market市场 数据
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
        //            .map { (markerDataModel) -> [StatisticModel] in
        //                var stats:[StatisticModel] = []
        //
        //                guard let data = markerDataModel else {
        //                    return stats
        //                }
        //
        //                let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        //
        //                let volume = StatisticModel(title: "24h Volume", value: data.volume)
        //                let btcDominance = StatisticModel(title: "BTC Dominance",value: data.btcDominance)
        //                let portfolio = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        //
        //                stats.append(contentsOf: [
        //                    marketCap,
        //                    volume,
        //                    btcDominance,
        //                    portfolio
        //                ])
        //                return stats
        //            }
            .sink { [weak self](returnedStats) in
                self?.statistics = returnedStats
                self?.isloading = false
            }
            .store(in: &cancellables)
        
        
    }
    
    func updatePortfolio(coin:CoinModel,amount:Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData(){
        isloading = true
        coinDataService.getCoin()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSordCoins(text:String, coins:[CoinModel],sort:SortOption) -> [CoinModel]{
        var updateCoins = filterCoin(text: text, coins: coins)
        soreCoins(sort: sort, coins: &updateCoins)
        return updateCoins
    }
    
    private func filterCoin(text:String, coins:[CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else{
            return coins
        }
        //将所有内容过滤为小写
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func soreCoins(sort:SortOption,  coins: inout [CoinModel]){
        switch sort {
            case .rank,.holdings:
                 coins.sort(by: { $0.rank < $1.rank })
            case .rankReversed,.holdingsReversed:
                 coins.sort(by: { $0.rank < $1.rank })
            case .price:
                 coins.sort(by: { $0.currentPrice < $1.currentPrice })
            case .priceReversed:
                 coins.sort(by: { $0.currentPrice < $1.currentPrice })

        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins:[CoinModel]) -> [CoinModel]{
        //只会按持股或反向持股排序
        switch sortOption {
            case .holdings:
                return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
            case .holdingsReversed:
                return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
            default:
                return coins
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins:[CoinModel],portfolioCoins:[PortfolioEntity]) ->[CoinModel] {
        allCoins
            .compactMap { coin -> CoinModel? in
                guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }

    }
    
    private func mapGlobalMarketData(markerDataModel:MarketDataModel?,portfolioCoins:[CoinModel]) ->[StatisticModel] {
        var stats:[StatisticModel] = []
        
        guard let data = markerDataModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance",value: data.btcDominance)
        
        
        let portfolioValue = portfolioCoins.map({ $0.currentHoldingsValue})
            .reduce(0, +)
        
        let previousValue =
        portfolioCoins
            .map { coin -> Double in
                let currenValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currenValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue)
        
        let portfolio = StatisticModel(
            title: "Portfolio Value",
            value:portfolioValue.asCurrencyWith2Decimals(),
            percentageChange: percentageChange )
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
