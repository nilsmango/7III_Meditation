//
//  StreakTile.swift
//  Meditation
//
//  Created by Simon Lang on 27.05.2024.
//

import SwiftUI

struct StreakTile: View {
    let streakText: String
    let streakNumber: String
    let frameWidth: Double
    
    var body: some View {
        VStack {
            Text(streakText)
            Text(streakNumber)
                .font(.system(size: 45))
                .fontDesign(.rounded)
                .fontWeight(.bold)
        }
        .padding()
        .frame(width: frameWidth, height: frameWidth)
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.whiteAndListGray)
        }
    }
}

#Preview {
    
    StreakTile(streakText: "Active Streak", streakNumber: "123", frameWidth: 165)
        .frame(width: 5000, height: 5000)
        .background(.customGray)
}
