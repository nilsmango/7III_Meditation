//
//  StatisticsButton.swift
//  Meditation
//
//  Created by Simon Lang on 28.05.2024.
//

import SwiftUI

struct StatisticsButton: View {
    let padding: Double
    
    var body: some View {
        Label("Statistics", systemImage: "chart.bar.xaxis")
            .font(.subheadline)
            .labelStyle(.iconOnly)
            .foregroundStyle(.white)
            .padding(padding)
            .background {
                Circle()
                    .foregroundStyle(.redAccent)
            }
    }
}

#Preview {
    StatisticsButton(padding: 5.5)
}
