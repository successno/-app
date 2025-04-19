//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/19.
//

import Foundation

extension String {
    
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "",options: .regularExpression,range: nil)
    }
    
}
