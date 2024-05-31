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
        if timerInMinutes > 60 {
            Text("0:00:00")
                .font(.title)
                .fontWeight(.bold)
                .hidden()
                .overlay(alignment: .leading) {
                    Text(targetDate, style: .timer)
                        .font(.title)
                        .fontWeight(.bold)
                }
        } else if timerInMinutes > 10 {
            Text("00:00")
                .font(.title)
                .fontWeight(.bold)
                .hidden()
                .overlay(alignment: .leading) {
                    Text(targetDate, style: .timer)
                        .font(.title)
                        .fontWeight(.bold)
                }
        } else {
            Text("0:00")
                .font(.title)
                .fontWeight(.bold)
                .hidden()
                .overlay(alignment: .leading) {
                    Text(targetDate, style: .timer)
                        .font(.title)
                        .fontWeight(.bold)
                }
        }
    }
}

#Preview {
    TimerHackView(targetDate: Date().addingTimeInterval(600), timerInMinutes: 10)
}
