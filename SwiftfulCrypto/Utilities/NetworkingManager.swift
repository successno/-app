//
//  NetworkingManager.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/8.
//

import Foundation
import Combine

class NetworkingManager {
    //NetworkingError
    enum CoinDataServiceError:LocalizedError{
        case badURLResponse(url:URL)
        case unknow
        case decodingError
        case networkError(Error)
        
        var errorDescription: String?{
            switch self{
                case .badURLResponse(url: let url ): return "Bad response from URL:\(url)"
                case .unknow: return "Unknown error occured"
                case .decodingError: return "Decoding error"
                case .networkError: return "NetworkError"
            }
        }
    }
    
    static func download(url:URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( {try handleURLResponse(output: $0 , url:url) } )
            .retry(3)
            //.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output:URLSession.DataTaskPublisher.Output, url:URL) throws -> Data {
       // throw NetworkingError.badURLResponse(url: url)
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw CoinDataServiceError.badURLResponse(url: url)
        }
        return output.data
    }
    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion{
            case .finished:
                break
            case.failure(let error):
                print(error.localizedDescription)
        }
    }

}

