//
//  TimerHackView.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import SwiftUI

struct TimerHackView: View {
    let targetDate: Date
    let timerInMinutes: Int
    
    var body: some View {
        Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double((timerInMinutes - 1) * 60))))
            .font(.title)
            .fontWeight(.bold)
            .monospacedDigit()
            .hidden()
            .overlay(alignment: .leading) {
                Text(targetDate, style: .timer)
                    .font(.title)
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
    }
}

#Preview {
    TimerHackView(targetDate: Date().addingTimeInterval(600), timerInMinutes: 10)
        .background {
            Color.green
        }
}
