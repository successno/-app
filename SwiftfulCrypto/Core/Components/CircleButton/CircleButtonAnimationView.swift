//
//  CircleButtonAnimationView.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none ,value: animate)
        //.onAppear 是一个视图修饰符，它允许你在视图出现在屏幕上时执行特定的代码。这个修饰符非常有用，比如你可以在视图出现时加载数据、初始化一些状态或者执行一些动画
//            .onAppear{
//                animate.toggle()
//            }
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(false))
        .foregroundColor(.red)
        .frame(width: 100,height: 100)
}
