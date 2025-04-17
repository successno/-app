//
//  Double.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import Foundation


extension Double{
    
    /// 将双精度类型转换为具有2位小数的的货币
    /// ```
    /// Convert 1234.56 to $1,234.56
    ///
    /// ```
    
    
    // NumberFormatter：数字格式化器
    private var currencyFormatter2:NumberFormatter{
        let formatted = NumberFormatter()
        //这行代码启用了数字分组分隔符。例如，对于较大的数字，会按照千位进行分隔，如 1,000,000。分组分隔符的具体样式取决于当前的 locale 设置
        formatted.usesGroupingSeparator = true
        //将数字样式设置为货币样式
        formatted.numberStyle = .currency
        
        formatted.locale = .current //默认值
        formatted.currencyCode = "usd" // 改变货币
        formatted.currencySymbol = "$" // 货币符号
        //小数长度
        formatted.minimumFractionDigits = 2
        formatted.maximumFractionDigits = 2
        return formatted
    }
    
    ///将Double类型转换为具有2～6位小数点的String类型货币
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// ```
    ///
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    
    
    
    /// 将双精度类型转换为具有2～6位小数的的货币
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $1.23456
    /// Convert 0.123456 to $0.123456
    /// ```
    // NumberFormatter：数字格式化器
    private var currencyFormatter6:NumberFormatter{
        let formatted = NumberFormatter()
        //这行代码启用了数字分组分隔符。例如，对于较大的数字，会按照千位进行分隔，如 1,000,000。分组分隔符的具体样式取决于当前的 locale 设置
        formatted.usesGroupingSeparator = true
        //将数字样式设置为货币样式
        formatted.numberStyle = .currency
        
        formatted.locale = .current //默认值
        formatted.currencyCode = "usd" // 改变货币
        formatted.currencySymbol = "$" // 货币符号
        //小数长度
        formatted.minimumFractionDigits = 2
        formatted.maximumFractionDigits = 6
        return formatted
    }
    
    ///将Double类型转换为具有2～6位小数点的String类型货币
    /// ```
    /// Convert 1234.56 to "$1,234,56"
    /// Convert 12.3456 to "$1.23456"
    /// Convert 0.123456 to "$0.123456"
    /// ```
    ///
    func asCurrencyWith6Decimals() -> String {
     let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    ///将Double类型转换为String类型表示
    /// ```
    /// Convert 1.2345 to "1.23"
    /// ```
    func asNumberString() -> String{
        
        return String(format: "%.2f", self)
    }
    
    /// 将Double类型转换为带有%符号的String类型表示
    /// ```
    /// Convert 1.2345 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    /// 将double转换为string，其中包含 K、M、Bn、Tr缩写形式
    /// ```
    /// Convert 12 to 12.00
    /// Convert 1234 to 1.23K
    /// Convert 123456 to 123.45K
    /// Convert 12345678 to 12.34M
    /// Convert 1234567890 to 1.23Bn
    /// Convert 123456789012 to 123.45Bn
    /// Convert 12345678901234 to 12.34Tr
    /// ```
    func formattedWithAbbreviations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
            case 1_000_000_000_000...:
                let formatted = num / 1_000_000_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted)Tr"
            case 1_000_000_000...:
                let formatted = num / 1_000_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted)Bn"
            case 1_000_000...:
                let formatted = num / 1_000_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted)M"
            case 1_000...:
                let formatted = num / 1_000
                let stringFormatted = formatted.asNumberString()
                return "\(sign)\(stringFormatted)K"
            case 0...:
                return self.asNumberString()
                
            default:
                return "\(sign)\(self)"
        }
    }
    
}
