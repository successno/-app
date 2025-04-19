//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/17.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketDataModel? = nil
    
    //    var coinSubscription: AnyCancellable?
    var marketDatacancellable = Set<AnyCancellable>()
    
    init(){
        getData()
    }

    // let url = URL(string: "https://api.coingecko.com/api/v3/global")!
    private func buildURL() -> URL?{
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")else {return nil}
        return url
    }
    
     func getData() {
        guard let url = buildURL() else {
            let error = NetworkingManager.CoinDataServiceError.self
            print(error.unknow)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        setupRequestHeaders(for: &request)
        
        //     let publisher = URLSession.shared.dataTaskPublisher(for: request)
        
        NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)

            .mapError { error in
                if error is NetworkingManager.CoinDataServiceError{
                    return NetworkingManager.CoinDataServiceError.decodingError
                }
                return NetworkingManager.CoinDataServiceError.networkError(error)
            }
        
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] (returnGlobalData) in
                self?.marketData = returnGlobalData.data
                //self?.coinSubscription?.cancel()
            })
            .store(in: &marketDatacancellable)
    }
    
    // 将请求头设置逻辑提取到一个单独的方法中，便于维护和修改
    private func setupRequestHeaders(for request: inout URLRequest) {
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
        ]
    }


}
