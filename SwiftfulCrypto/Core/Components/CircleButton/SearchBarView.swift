//
//  SearchBarView.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/9.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText:String
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundColor(
                    searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent
                )
            TextField("按名称或符号搜索...", text: $searchText)
                .foregroundColor(Color.theme.accent)
            //.disableAutocorrection(true)
            // 局内键盘的自动更正
            //这个方法的作用是禁用自动更正功能。在用户输入文本时，系统通常会尝试自动纠正拼写错误，不过在某些情形下，比如输入用户名、密码、特定代码等，用户可能不希望系统自动更正输入内容，此时就可以调用这个方法来禁用该功能。
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(Color.theme.accent)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        },alignment: .trailing
                )
        }
        .font(.headline)
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color.theme.background)
                .cornerRadius(25)
                .shadow(
                    color: Color.theme.accent.opacity(0.15),
                    radius: 20,x: 0,y: 0
                )
        )
        .padding()
        
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
