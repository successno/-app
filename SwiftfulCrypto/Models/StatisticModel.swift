//
//  StatisticModel.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/17.
//

import Foundation

struct StatisticModel: Identifiable {
    let id = UUID().uuidString
    
    let title: String
    
    let value: String
    //百分比
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}


