//
//  CoinImageViewModel.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/9.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel:ObservableObject{
    
    @Published var image:UIImage? = nil
    @Published var isloading:Bool = false
    @Published var cancellables = Set<AnyCancellable>()
    
    private let dataService : CoinImageService
    
    private let coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        dataService.$image
            .sink { [weak self] (_) in
                self?.isloading = false
            } receiveValue: { [weak self] returnImage in
                self?.image = returnImage
            }
            .store(in: &cancellables)
        
    }
    
    
}
