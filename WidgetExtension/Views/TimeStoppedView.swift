//
//  TimeStoppedView.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import SwiftUI

struct TimeStoppedView: View {
    var timerInMinutes: Int
    
    var body: some View {
        Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
            .font(.title)
            .fontWeight(.bold)
            .monospacedDigit()
    }
}

#Preview {
    TimeStoppedView(timerInMinutes: 10)
}
