//
//  LaunchView.swift
//  SwiftfulCrypto
//
//  Created by Star. on 2025/4/19.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var loadingText: [String] = "Lodaing your portfolio...".map{ String($0) }
    @State private var showLoadingText: Bool = false
    
    //当调用 autoconnect() 后，这个基于 Timer 创建的 Publisher 会自动建立订阅关系并开始发送事件。如果不调用 autoconnect() ，则需要手动通过 sink 等方法来建立订阅，定时器才会实际运行并发出事件。通过 autoconnect() 可以更便捷地让定时器开始工作，只要创建了这个定时器对象，它就会按照设定的时间间隔不断触发并发布事件。
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView:Bool
    
    var body: some View {
        ZStack{
            Color.launch.baceground
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
            
            ZStack{
                if showLoadingText{
//                    Text(loadingText)

                    HStack(spacing: 0){
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset( y: counter == index ? -5 : 0)
                        }
                    }
                    .transition(AnyTransition.scale.animation(.easeIn))
                    
                }
     
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {
                
                let lastIndex = loadingText.count - 1
                if lastIndex == counter {
                    counter = 0
                    loops += 1
                    if loops >= 2 {
                        showLaunchView = false
                    }
                    
                }else{
                    counter += 1

                }
            }
        }
    }
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
