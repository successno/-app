//
//  CoinDetailModel.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
import Foundation

//JSON DATA
/*
 import Foundation
 
 let url = URL(string: "https://api.coingecko.com/api/v3/coins/bitcoin")!
 var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
 let queryItems: [URLQueryItem] = [
 URLQueryItem(name: "localization", value: "false"),
 URLQueryItem(name: "tickers", value: "false"),
 URLQueryItem(name: "market_data", value: "false"),
 URLQueryItem(name: "community_data", value: "false"),
 URLQueryItem(name: "developer_data", value: "false"),
 URLQueryItem(name: "sparkline", value: "false"),
 ]
 components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
 
 var request = URLRequest(url: components.url!)
 request.httpMethod = "GET"
 request.timeoutInterval = 10
 request.allHTTPHeaderFields = [
 "accept": "application/json",
 "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
 ]

 */


struct CoinDetailModel:Codable {
 let id, symbol, name: String?
 let blockTimeInMinutes: Int?
 let hashingAlgorithm: String?
 let description: Description?
 let links: Links?
     
     enum CodingKeys:String,CodingKey {
         case id,symbol,name,description,links
         case blockTimeInMinutes
         case hashingAlgorithm
     }
 }

struct Description :Codable{
 let en: String?
 }
 
struct Links:Codable {
 let homepage: [String]?
 let subredditURL: String?
     
     enum CodingKeys:String,CodingKey {
         case homepage
         case subredditURL
     }
 }
 
