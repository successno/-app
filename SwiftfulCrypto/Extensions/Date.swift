//
//  Date.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//

import Foundation

extension Date {
    
    //2024-04-07T16:49:31.736Z
    init(coinGeckoSrting:String){
        let formatted = DateFormatter()
        formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatted.date(from: coinGeckoSrting) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter:DateFormatter{
        let formatted = DateFormatter()
        formatted.dateStyle = .short
        return formatted
    }
    
    func asShortDateString()-> String {
        return shortFormatter.string(from: self)
    }
    
}
