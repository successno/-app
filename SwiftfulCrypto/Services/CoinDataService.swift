////
////  CoinDataService.swift
////  SwiftfulCrypto
////
////  Created by Outsider on 2025/4/8.
////
//
import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []

//    var coinSubscription: AnyCancellable?
    var cancellable = Set<AnyCancellable>()
    
    init(){
        getCoin()
    }

   // private func getCoins() { }
        /*
        //URLComponents 是 Foundation 框架中的一个类，它可以帮助开发者更方便地创建、修改和解析 URL。借助 URLComponents，你能够灵活处理 URL 的各个部分，像协议、主机、路径、查询参数等，而无需手动拼接字符串，降低了出错的可能性，增强了代码的可读性和可维护性。
        
        //URL 一般由多个部分构成，例如协议（如 https）、主机（如 example.com）、路径（如 /api/data）、查询参数（如 key=value）等。URLComponents 类允许你分别对这些部分进行操作，之后再组合成完整的 URL
        
        //scheme：字符串类型，代表 URL 的协议部分，像 http、https 等。
        //host：字符串类型，表示 URL 的主机名，例如 example.com。
        //port：可选的整数类型，是 URL 的端口号，比如 80、443 等。
        //path：字符串类型，指 URL 的路径部分，例如 /api/data。
        //queryItems：可选的 [URLQueryItem] 类型，用于存储 URL 的查询参数，每个 URLQueryItem 代表一个键值对。
        //fragment：字符串类型，是 URL 的片段部分，位于 # 符号之后
        
        //true：如果传入的 URL 是相对 URL，会将其解析为相对于基础 URL 的完整 URL。也就是会结合基础 URL 的协议、主机、路径等信息，把相对 URL 补全成完整的绝对 URL。
        //false：无论传入的 URL 是否为相对 URL，都不会使用基础 URL 来解析，而是直接使用传入的 URL 作为 URLComponents 的基础
        
//        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets") else { return }
//        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        //URLQueryItem 是 Swift 中 Foundation 框架里的一个类，用于表示 URL 查询字符串中的一个键值对。在构建包含查询参数的 URL 时，它非常有用，能够帮助你轻松地创建和管理 URL 的查询部分。以下为你详细介绍它的相关信息
//        let queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "vs_currency", value: "usd"),
//            URLQueryItem(name: "per_page", value: "250"),
//            URLQueryItem(name: "sparkline", value: "true"),
//            URLQueryItem(name: "price_change_percentage", value: "24h"),
//            URLQueryItem(name: "locale", value: "zh"),
//            URLQueryItem(name: "precision", value: "2")
//        ]
//        components.queryItems = (components.queryItems ?? []) + queryItems
////        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
//        
//        //URLRequest 代表一个统一资源定位符（URL）请求，它能包含请求的 URL、HTTP 方法（如 GET、POST 等）、请求头、请求体等信息。借助 URLRequest，你可以精确控制请求的各个方面，从而实现不同类型的网络请求。
//        var request = URLRequest(url: components.url!)
//        
//        //httpMethod：用于指定 HTTP 请求的方法，类型为 String。常见的值有 "GET"、"POST"、"PUT"、"DELETE" 等
//        request.httpMethod = "GET"
//        //该属性用于设置请求的超时时间，单位是秒，类型为 TimeInterval
//        request.timeoutInterval = 10
//        //allHTTPHeaderFields：它是一个 [String: String] 类型的字典，用于设置请求头信息
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
//        ]
        
        */
        
        private func buildURL() -> URL?{
            guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets")else {return nil}
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

  func getCoin() {
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
                .decode(type: [CoinModel].self, decoder: JSONDecoder())
     
                .mapError { error in
                    if error is NetworkingManager.CoinDataServiceError{
                        return NetworkingManager.CoinDataServiceError.decodingError
                                    }
                    return NetworkingManager.CoinDataServiceError.networkError(error)
                                }
     
                .sink(receiveCompletion: NetworkingManager.handleCompletion,
                      receiveValue: { [weak self] (returnCoins) in
                    self?.allCoins = returnCoins
                    //self?.coinSubscription?.cancel()
                })
                .store(in: &cancellable)
        }
    
    // 将请求头设置逻辑提取到一个单独的方法中，便于维护和修改
    private func setupRequestHeaders(for request: inout URLRequest) {
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
        ]
    }
    
    
}


/*
//import Foundation
//import Combine
//
//// 定义一个专门的错误枚举，用于更清晰地表示 API 请求过程中的错误类型
//enum CoinDataServiceError: Error {
//    case invalidURL
//    case networkError(Error)
//    case decodingError(DecodingError)
//    case badServerResponse
//}
//
//class CoinDataService {
//    @Published var allCoins: [CoinModel] = []
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        getCoin()
//    }
//    
//    // 将 URL 构建逻辑提取到一个单独的方法中，提高代码的可读性和复用性
//    private func buildURL() -> URL? {
//        guard let baseURL = URL(string: "https://api.coingecko.com/api/v3/coins/markets") else {
//            return nil
//        }
//        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
//        let queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "vs_currency", value: "usd"),
//            URLQueryItem(name: "per_page", value: "250"),
//            URLQueryItem(name: "sparkline", value: "true"),
//            URLQueryItem(name: "price_change_percentage", value: "24h"),
//            URLQueryItem(name: "locale", value: "zh"),
//            URLQueryItem(name: "precision", value: "2")
//        ]
//        
//        // 将 components 复制到一个局部变量中
//        var tempComponents = components
//        
//        // 处理 tempComponents.queryItems 可能为 nil 的情况
//        var combinedQueryItems = [URLQueryItem]()
//        if let existingQueryItems = tempComponents?.queryItems {
//            combinedQueryItems = existingQueryItems + queryItems
//        } else {
//            combinedQueryItems = queryItems
//        }
//        
//        // 将合并后的查询参数赋值给 tempComponents.queryItems
//        tempComponents?.queryItems = combinedQueryItems
//        
//        // 将修改后的 tempComponents 赋值回 components
//        components = tempComponents
//        return components?.url
//    }
//    
//    // 将请求头设置逻辑提取到一个单独的方法中，便于维护和修改
//    private func setupRequestHeaders(for request: inout URLRequest) {
//        request.allHTTPHeaderFields = [
//            "accept": "application/json",
//            "x-cg-demo-api-key": "CG-pbJkNREr58h2ATQsUV3XJZJ9"
//        ]
//    }
//    
//    private func getCoin() {
//        guard let url = buildURL() else {
//            // 更好的错误处理，将错误发布出去而不是仅仅打印
//            let error = CoinDataServiceError.invalidURL
//            print(error.localizedDescription)
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.timeoutInterval = 10
//        setupRequestHeaders(for: &request)
//        
//        // 使用 flatMap 操作符将不同类型的错误转换为统一的错误类型
//        let publisher = URLSession.shared.dataTaskPublisher(for: request)
//            .subscribe(on: DispatchQueue.global(qos: .default))
//            .tryMap { (output) -> Data in
//                guard let response = output.response as? HTTPURLResponse,
//                      response.statusCode >= 200 && response.statusCode < 300 else {
//                    throw CoinDataServiceError.badServerResponse
//                }
//                return output.data
//            }

//            .receive(on: DispatchQueue.main)
//            .decode(type: [CoinModel].self, decoder: JSONDecoder())
//            .mapError { error in
//                if let decodingError = error as? DecodingError {
//                    return CoinDataServiceError.decodingError(decodingError)
//                }
//                return CoinDataServiceError.networkError(error)
//            }
//        
//        // 将订阅存储在 cancellables 集合中，确保在对象销毁时可以取消订阅，避免内存泄漏
//        publisher
//            .sink ( receiveCompletion: NetworkingManager.handleCompletion,
//             receiveValue: { [weak self] returnedCoins in
//                self?.allCoins = returnedCoins
//            })
//            .store(in: &cancellables)
//    }
//}
 */
