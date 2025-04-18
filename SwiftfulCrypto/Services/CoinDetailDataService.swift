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
    
    var coinDetailcancellable = Set<AnyCancellable>()
    let coin: CoinModel
    
    init(coin: CoinModel){
        self.coin = coin
        getCoinDetails()
    }
    
    private func buildURL() -> URL?{
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins\(coin.id)")else {return nil}
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "localization", value: "false"),
            URLQueryItem(name: "tickers", value: "false"),
            URLQueryItem(name: "market_data", value: "false"),
            URLQueryItem(name: "community_data", value: "false"),
            URLQueryItem(name: "developer_data", value: "false"),
            URLQueryItem(name: "sparkline", value: "false"),
        ]
        
        var tempComponents = components
        
        var combinedQueryItems = [URLQueryItem]()
        if let existingQueryItems = tempComponents.queryItems {
            combinedQueryItems = existingQueryItems + queryItems
        } else {
            combinedQueryItems = queryItems
        }

        tempComponents.queryItems = combinedQueryItems

        components = tempComponents
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

        NetworkingManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
        
            .mapError { error in
                if error is NetworkingManager.CoinDataServiceError{
                    return NetworkingManager.CoinDataServiceError.decodingError
                }
                return NetworkingManager.CoinDataServiceError.networkError(error)
            }
        
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (returnCoinDetails) in
                self?.coinDetails = returnCoinDetails
            })
            .store(in: &coinDetailcancellable)
    }
    
    private func setupRequestHeaders(for request: inout URLRequest) {
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
        ]
    }
    
    
}
