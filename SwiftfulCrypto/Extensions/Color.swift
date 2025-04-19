//
//  Color.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import Foundation
import SwiftUI


extension Color {
 
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
}

    //主题颜色
struct ColorTheme{
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor1")
    let red = Color("RedColor1")
    let secondaryText = Color("SecondaryTextColor")
    
}

struct LaunchTheme{
    
    let accent = Color("LaunchAccentColor")
    let baceground = Color("LaunchBackgroundColor")
    
}
