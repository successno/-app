//
//  CoinImageService.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/9.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
   
    @Published var image: UIImage? = nil
    
//    private var imageSubscription:AnyCancellable?
    var cancellable = Set<AnyCancellable>()
    private let coin:CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coim_images"
    private let imageName:String?
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
       getCoinImage()
    }
    
    private func getCoinImage(){
        guard let imageName  = imageName else{return}
        if let saveImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = saveImage
            //print("从文件管理器中检索图像")
        } else {
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
       // print("正在下载...")
        guard let url = buildURL() else {
            print(NetworkingManager.CoinDataServiceError.unknow)
            return
        }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            setupRequestHeaders(for: &request)
            
            NetworkingManager.download(url: url)
                .tryMap({ (data) -> UIImage? in
                    return UIImage(data: data)
                })
            
                .mapError { error in
                    if error is NetworkingManager.CoinDataServiceError{
                        return NetworkingManager.CoinDataServiceError.decodingError
                    }
                    return NetworkingManager.CoinDataServiceError.networkError(error)
                }
            
                .sink(receiveCompletion: NetworkingManager.handleCompletion,
                      receiveValue: { [weak self] (returnImage) in
                    guard let self = self,
                            let downloadedImage = returnImage,
                          let imageName = self.imageName
                    else { return }

                    self.image = downloadedImage
                    self.fileManager.savaImage(image: downloadedImage, imageName: imageName, folderName: folderName)
                })
                .store(in: &cancellable)
    }


    
    private  func buildURL() -> URL?{
        guard
            let url = URL(string: coin.image) else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "per_page", value: "250"),
            URLQueryItem(name: "sparkline", value: "true"),
            URLQueryItem(name: "price_change_percentage", value: "24h"),
            URLQueryItem(name: "locale", value: "zh"),
            URLQueryItem(name: "precision", value: "2"),
        ]
        // 将 components 复制到一个局部变量中
        var tempComponents = components
        
        // 处理 tempComponents.queryItems 可能为 nil 的情况
        var combinedQueryItems = [URLQueryItem]()
        if let existingQueryItems = tempComponents.queryItems {
            combinedQueryItems = existingQueryItems + queryItems
        } else {
            combinedQueryItems = queryItems
        }
        // 将合并后的查询参数赋值给 tempComponents.queryItems
        tempComponents.queryItems = combinedQueryItems
        // 将修改后的 tempComponents 赋值回 components
        components = tempComponents
        return components.url
    }
    
    
        // 将请求头设置逻辑提取到一个单独的方法中，便于维护和修改
    private  func setupRequestHeaders(for request: inout URLRequest) {
            request.allHTTPHeaderFields = [
                "accept": "application/json",
                "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
            ]
        }
}

/*
class CoinImageService {
    
    @Published var image: UIImage? = nil
    var cancellable = Set<AnyCancellable>()
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        guard let url = buildURL() else {
            print(NetworkingManager.CoinDataServiceError.unknow)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        setupRequestHeaders(for: &request)
        
        NetworkingManager.download(url: url)
            .tryMap { data in
                return UIImage(data: data)
            }
            .mapError { error in
                if error is NetworkingManager.CoinDataServiceError {
                    return NetworkingManager.CoinDataServiceError.decodingError
                }
                return NetworkingManager.CoinDataServiceError.networkError(error)
            }
            .sink(receiveCompletion: NetworkingManager.handleCompletion,
                  receiveValue: { [weak self] returnImage in
                self?.image = returnImage
            })
            .store(in: &cancellable)
    }
    
    private func buildURL() -> URL? {
        guard let imageURLString = coin.image, let url = URL(string: imageURLString) else {
            return nil
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "per_page", value: "250"),
            URLQueryItem(name: "sparkline", value: "true"),
            URLQueryItem(name: "price_change_percentage", value: "24h"),
            URLQueryItem(name: "locale", value: "zh"),
            URLQueryItem(name: "precision", value: "2")
        ]
        
        var combinedQueryItems = [URLQueryItem]()
        if let existingQueryItems = components.queryItems {
            combinedQueryItems = existingQueryItems + queryItems
        } else {
            combinedQueryItems = queryItems
        }
        components.queryItems = combinedQueryItems
        return components.url
    }
    
    private func setupRequestHeaders(for request: inout URLRequest) {
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
        ]
    }
}
*/
