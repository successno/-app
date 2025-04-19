//
//  CoinDetailDataService.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//
import Foundation
import Combine

class CoinDetailDataService {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    var coinDetailcancellable : AnyCancellable?
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinDetails()
    }
    
    private func buildURL() -> URL?{
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)")else {return nil}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "localization", value: "false"),
            URLQueryItem(name: "tickers", value: "false"),
            URLQueryItem(name: "market_data", value: "false"),
            URLQueryItem(name: "community_data", value: "false"),
            URLQueryItem(name: "developer_data", value: "false"),
            URLQueryItem(name: "sparkline", value: "false"),
        ]

//        var tempComponents = components
//        
//        var combinedQueryItems = [URLQueryItem]()
//        if let existingQueryItems = tempComponents.queryItems {
//            combinedQueryItems = existingQueryItems + queryItems
//        } else {
//            combinedQueryItems = queryItems
//        }
//
//        tempComponents.queryItems = combinedQueryItems
//
//        components = tempComponents
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url
    }
    
    func getCoinDetails() {
        guard let url = buildURL() else {
            let error = NetworkingManager.CoinDataServiceError.self
            print(error.unknow)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        setupRequestHeaders(for: &request)
        
        //JSONDecoder 是用于将 JSON 数据解码为 Swift 结构体或类实例的工具。当你设置 decoder.keyDecodingStrategy =.convertFromSnakeCase 时，
        //它的作用是指定解码时的键解码策略，使得 JSONDecoder 能够将 JSON 数据中以下划线命名法（snake case）命名的键，自动转换为 Swift 结构体或类中以驼峰命名法（camel case）命名的属性。
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        coinDetailcancellable = NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

            .mapError { error in
                if error is NetworkingManager.CoinDataServiceError{
                    return NetworkingManager.CoinDataServiceError.decodingError
                }
                return NetworkingManager.CoinDataServiceError.networkError(error)
            }
        
        
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                        case.finished:
                            print("数据获取成功")
                        case.failure(let error):
                            print("数据获取失败: \(error)")
                    }
                },
//                receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (returnCoinDetails) in
                self?.coinDetails = returnCoinDetails
                self?.coinDetailcancellable?.cancel()
            })
           
    }
    
    private func setupRequestHeaders(for request: inout URLRequest) {
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
        ]
    }
    
    deinit {
        coinDetailcancellable?.cancel()
    }

}


