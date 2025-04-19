//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    @State private var showLauchView:Bool = true
    
    init(){
        //在应用启动时设置导航栏外观
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        
        UITableView.appearance().backgroundColor = UIColor.clear
        
    }
    
    var body: some Scene {
        WindowGroup {
            
            ZStack{
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
                
                ZStack{
                    if showLauchView{
                        LaunchView(showLaunchView: $showLauchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
            
         
        }
    }
}
