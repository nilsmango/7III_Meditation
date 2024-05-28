//
//  StreakButton.swift
//  Meditation
//
//  Created by Simon Lang on 26.05.2024.
//

import SwiftUI

struct StreakButton: View {
    var streakNumber: Int
    
    var streakAppendix: String {
        if streakNumber > 0 {
            return " 🔥"
        } else {
            return " 😐"
        }
    }
    
    var body: some View {
        Text(String(streakNumber) + streakAppendix)
            .fontDesign(.rounded)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.blackAndWhite, .accent)
            .padding(6)
            .background {
                Capsule()
                    .foregroundStyle(.whiteAndBlack)
            }
    }
}

#Preview {
    VStack {
        HStack {
            StreakButton(streakNumber: 0)
                .padding(.horizontal)
            Spacer()
        }
        Spacer()
    }
    .background(LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom))
}
