//
//  TimerStoppedView.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct TimerStoppedView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    let padding = UIScreen.main.bounds.width / 6
    
    var body: some View {
        Spacer()
        
        Picker("Time", selection: $meditationManager.meditationTimer.timerInMinutes) {
            ForEach(1...300, id: \.self) { minutes in
                Text("\(minutes) \(minutes == 1 ? "Minute" : "Minutes")")
            }
        }
        .pickerStyle(WheelPickerStyle())
        .padding(.horizontal, padding)
    
        Spacer(minLength: 0.0)
        
    Button(action: {
            meditationManager.startMeditation()
    }, label: {
        Text("Start")

    })
    .buttonStyle(CircleButtonStyle())
        
    }
}

#Preview {
    VStack {
        Spacer()
        TimerStoppedView(meditationManager: MeditationManager())
        Spacer()
    }
}
