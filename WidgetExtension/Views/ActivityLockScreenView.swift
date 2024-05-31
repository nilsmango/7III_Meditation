//
//  ActivityLockScreenView.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import SwiftUI

struct ActivityLockScreenView: View {
    let timerStatus: TimerStatus
    let targetDate: Date
    let timerInMinutes: Int
    let welcomeBackText: String
    let koanText: String
    
    let frameWidth: Double
    var body: some View {
        VStack {
            Spacer()
            HStack {
                switch timerStatus {
                case .running:
                    
                    Button(intent: PauseMeditation()) {
                        WidgetButtonLabel(buttonState: .pause)
                    }
                    .widgetButtonStyle(frameWidth: frameWidth)
                    
                    Button(intent: StopMeditation()) {
                        WidgetButtonLabel(buttonState: .stop)
                    }
                    .widgetButtonStyle(frameWidth: frameWidth)
                    
                    Spacer()
                    
                    TimerHackView(targetDate: targetDate, timerInMinutes: timerInMinutes)
                    
                    Spacer()
                    
                    CircleProgressView(timerStatus: timerStatus, targetDate: targetDate, timerInMinutes: timerInMinutes, expanded: true)
                        .frame(width: frameWidth)
                    
                    
                case .alarm:
                    Spacer()
                    Text(welcomeBackText)
                        .font(.title)
                    Spacer()
                case .stopped:
                    Spacer()
                    Text(welcomeBackText)
                        .font(.title)
                    Spacer()
                    
                case .paused:
                    
                    Button(intent: ResumeMeditation()) {
                        WidgetButtonLabel(buttonState: .resume)
                    }
                    .widgetButtonStyle(frameWidth: frameWidth)
                    
                    Button(intent: StopMeditationWithoutSaving()) {
                        WidgetButtonLabel(buttonState: .stop)
                    }
                    .widgetButtonStyle(frameWidth: frameWidth)
                    
                    Spacer()
                    
                    Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    CircleProgressView(timerStatus: timerStatus, targetDate: targetDate, timerInMinutes: timerInMinutes, expanded: true)
                        .frame(width: frameWidth)
                    
                case .preparing:
                    Text(koanText)
                        .font(.title)
                }
                
            }
            .frame(height: frameWidth)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ActivityLockScreenView(timerStatus: .paused, targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, welcomeBackText: "Welcome", koanText: "some koan", frameWidth: 50)
}
