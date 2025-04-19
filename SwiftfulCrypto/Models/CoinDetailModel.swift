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
 
 let (data, _) = try await URLSession.shared.data(for: request)
 print(String(decoding: data, as: UTF8.self))

 {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "block_time_in_minutes": 10,
 "hashing_algorithm": "SHA-256",
 
 "description": {
 "en": "Bitcoin is the first successful internet money based on peer-to-peer technology; whereby no central bank or authority is involved in the transaction and production of the Bitcoin currency. It was created by an anonymous individual/group under the name, Satoshi Nakamoto. The source code is available publicly as an open source project, anybody can look at it and be part of the developmental process.\r\n\r\nBitcoin is changing the way we see money as we speak. The idea was to produce a means of exchange, independent of any central authority, that could be transferred electronically in a secure, verifiable and immutable way. It is a decentralized peer-to-peer internet currency making mobile payment easy, very low transaction fees, protects your identity, and it works anywhere all the time with no central authority and banks.\r\n\r\nBitcoin is designed to have only 21 million BTC ever created, thus making it a deflationary currency. Bitcoin uses the SHA-256 hashing algorithm with an average transaction confirmation time of 10 minutes. Miners today are mining Bitcoin using ASIC chip dedicated to only mining Bitcoin, and the hash rate has shot up to peta hashes.\r\n\r\nBeing the first successful online cryptography currency, Bitcoin has inspired other alternative currencies such as Litecoin, Peercoin, Primecoin, and so on.\r\n\r\nThe cryptocurrency then took off with the innovation of the turing-complete smart contract by Ethereum which led to the development of other amazing projects such as EOS, Tron, and even crypto-collectibles such as CryptoKitties."
 },
 "links": {
 "homepage": [
 "http://www.bitcoin.org"
 ],
 "subreddit_url": "https://www.reddit.com/r/Bitcoin/"
 }
 }
 
 
 */


struct CoinDetailModel:Codable {
 let id, symbol, name: String?
 let blockTimeInMinutes: Int?
 let hashingAlgorithm: String?
 let description: Description?
 let links: Links?
     
     enum CodingKeys: String, CodingKey {
         case id,symbol,name,description,links
         case blockTimeInMinutes = "block_time_in_minutes"
         case hashingAlgorithm = "hashing_algorithm"
     }
    
    var readableDescription:String? {
        return description?.en?.removingHTMLOccurances
    }
    
 }

struct Links:Codable {
 let homepage: [String]?
 let subredditURL: String?
     
     enum CodingKeys:String,CodingKey {
         case homepage
         case subredditURL = "subreddit_url"
     }
 }
 
struct Description :Codable{
    let en: String?
    }


