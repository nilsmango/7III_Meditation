//
//  MainViewButton.swift
//  Meditation
//
//  Created by Simon Lang on 14.07.2025.
//

import SwiftUI

struct MainViewButton: View {
    var label: String
    var iconName: String
    var labelColor: Color
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 48))
                    .foregroundColor(labelColor)
                Text(label)
                    .foregroundColor(.primary)
            }
            .font(.title2)
            .fontWeight(.bold)
            
            .frame(width: UIScreen.main.bounds.width/3)
            .padding()
            .background(.buttonGray)
            .cornerRadius(10)
        }
    }
}

#Preview {
    HStack {
        Spacer()
        MainViewButton(label: "App Blocker", iconName: "shield.fill", labelColor: .greenAccent, action: {})
        Spacer()
        MainViewButton(label: "Meditation", iconName: "circle.fill", labelColor: .redAccent, action: {})
        Spacer()
    }
    
    
}
