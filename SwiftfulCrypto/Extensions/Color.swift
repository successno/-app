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

struct ColorTheme2 {
    let accent = Color(Color(red: 0.3, green: 0.5, blue: 2.0))
    let background = Color(Color(red: 0.7, green: 1.5, blue: 1.5))
    let green = Color(Color(red: 0.1, green: 1.0, blue: 0.1))
    let red = Color(Color(red: 1.0, green: 0.2, blue: 0.2))
    let secondaryText = Color(Color(red: 0.3, green: 0.8, blue: 0.2))
    
}

struct LaunchTheme{
    
    let accent = Color("LaunchAccentColor")
    let baceground = Color("LaunchBackgroundColor")
    
}
