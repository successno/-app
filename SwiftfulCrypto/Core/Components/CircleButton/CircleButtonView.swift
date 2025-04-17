//
//  CircleButtonView.swift
//  SwiftfulCrypto
//
//  Created by Outsider on 2025/4/7.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName:String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50,height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(
                color: Color.theme.accent.opacity(0.25),
                radius: 10)
            .padding()
    }
}

#Preview {
    Group{
        CircleButtonView(iconName: "info")
            .padding()
        
        CircleButtonView(iconName: "plus")
            .padding()
            //.preferredColorScheme(.dark)
            .colorScheme(.dark)
        
    }
   
}
