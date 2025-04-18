//
//  HapticManager.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/18.
//

import Foundation
import SwiftUI

class HapticManager {
    //ui通知反馈生成器
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type:UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
    
}
