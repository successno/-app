//
//  CoinModel.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import Foundation
//import Foundation

//let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
//var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//let queryItems: [URLQueryItem] = [
//    URLQueryItem(name: "vs_currency", value: "usd"),
//    URLQueryItem(name: "per_page", value: "250"),
//    URLQueryItem(name: "sparkline", value: "true"),
//    URLQueryItem(name: "price_change_percentage", value: "24h"),
//    URLQueryItem(name: "locale", value: "zh"),
//    URLQueryItem(name: "precision", value: "2"),
//]
//components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//
//var request = URLRequest(url: components.url!)
//request.httpMethod = "GET"
//request.timeoutInterval = 10
//request.allHTTPHeaderFields = [
//    "accept": "application/json",
//    "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
//]

//let (data, _) = try await URLSession.shared.data(for: request)
//print(String(decoding: data, as: UTF8.self))



/*

 

 let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")!
 var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
 let queryItems: [URLQueryItem] = [
 URLQueryItem(name: "vs_currency", value: "usd"),
 URLQueryItem(name: "per_page", value: "250"),
 URLQueryItem(name: "sparkline", value: "true"),
 URLQueryItem(name: "price_change_percentage", value: "24h"),
 URLQueryItem(name: "locale", value: "zh"),
 URLQueryItem(name: "precision", value: "2"),
 ]
 components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
 var request = URLRequest(url: components.url!)
 request.httpMethod = "GET"
 request.timeoutInterval = 10
 request.allHTTPHeaderFields = [
 "accept": "application/json",
 "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
 ]
 
 
 
 
 //JSON Response:
 
 [
 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
 "current_price": 70187,
 "market_cap": 1381651251183,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 1474623675796,
 "total_volume": 20154184933,
 "high_24h": 70215,
 "low_24h": 68060,
 "price_change_24h": 2126.88,
 "price_change_percentage_24h": 3.12502,
 "market_cap_change_24h": 44287678051,
 "market_cap_change_percentage_24h": 3.31157,
 "circulating_supply": 19675987,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 73738,
 "ath_change_percentage": -4.77063,
 "ath_date": "2024-03-14T07:10:36.635Z",
 "atl": 67.81,
 "atl_change_percentage": 103455.83335,
 "atl_date": "2013-07-06T00:00:00.000Z",
 "roi": null,
 "last_updated": "2024-04-07T16:49:31.736Z"
 }
 ]
 
 */


struct CoinModel:Identifiable, Codable ,Hashable{
    let id, symbol, name: String
    let image: String
    let currentPrice:Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let currentHoldings:Double?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    
    enum CodingKeys: String,CodingKey{
        case id, symbol,name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case currentHoldings
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    }
    
    //更新
    func updateHoldings(amount:Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, currentHoldings: amount,sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency)
    }
    //持股值变动
    var currentHoldingsValue:Double{
        return (currentHoldings ?? 0) * currentPrice
    }
    //排名
    var rank:Int{
        return Int(marketCapRank ?? 0)
    }
    
}
struct SparklineIn7D: Codable, Hashable {
    let price: [Double]?
}
