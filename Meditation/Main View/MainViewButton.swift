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
                Text(label)
            }
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(labelColor)
            .frame(width: UIScreen.main.bounds.width/3)
            .padding()
            .background(.customGray)
            .cornerRadius(10)
        }
    }
}

#Preview {
    HStack {
        Spacer()
        MainViewButton(label: "App Blocker", iconName: "shield.fill", labelColor: .greenAccent, action: {})
        Spacer()
        MainViewButton(label: "Meditation", iconName: "circle.fill", labelColor: .accent, action: {})
        Spacer()
    }
    
    
}
