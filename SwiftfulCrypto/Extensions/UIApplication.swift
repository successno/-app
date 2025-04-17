//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/9.
//

import Foundation
import SwiftUI



extension UIApplication {
    
    //方法内部调用了 sendAction(_:to:from:for:) 方法，这是 UIApplication 的一个实例方法，其参数解释如下：
    //#selector(UIResponder.resignFirstResponder)：这是一个选择器（Selector），指向 UIResponder 类的 resignFirstResponder 方法。resignFirstResponder 方法的作用是让调用它的 UIResponder 对象放弃第一响应者身份。
    //to: nil：表示将动作发送给谁。设置为 nil 时，UIApplication 会在响应者链中寻找能够处理 resignFirstResponder 动作的对象。
    //from: nil：表示动作的发起者。设置为 nil 表示不指定发起者。
    //for: nil：表示与动作相关的上下文信息。设置为 nil 表示不提供额外的上下文信息。
    
    //endEditing 方法的主要作用是让应用程序内所有处于第一响应者（正在接受用户输入）状态的 UIResponder 对象放弃第一响应者身份，也就是结束当前的文本编辑会话。这意味着所有正在编辑的文本框（如 UITextField、UITextView 等）会退出编辑模式，键盘会收起
    
    
    //在 Objective - C 里，消息传递机制允许在运行时动态地调用方法。Selector 就是用来表示一个方法的标识符。Swift 为了和 Objective - C 兼容，提供了 #selector 语法来创建 Selector 对象。
    //  #selector(methodName)
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}

