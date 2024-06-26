//
//  IslandExpandedBottomView.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import SwiftUI

struct IslandExpandedBottomView: View {
    let timerStatus: TimerStatus
    let targetDate: Date
    let timerInMinutes: Int
    let welcomeBackText: String
    let koanText: String
    let showKoan: Bool
    
    let frameWidth: Double
    
    var body: some View {
        switch timerStatus {
        case .running:
            HStack {
                
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
            }
            .frame(height: frameWidth)
            .padding(.top, 16)
            
        case .alarm:
            Text(welcomeBackText)
                .font(.title)
                .padding()
            
        case .paused:
            HStack {
                
                Button(intent: ResumeMeditation()) {
                    WidgetButtonLabel(buttonState: .resume)
                }
                .widgetButtonStyle(frameWidth: frameWidth)
                
                
                Button(intent: StopMeditationWithoutSaving()) {
                    WidgetButtonLabel(buttonState: .stop)
                }
                .widgetButtonStyle(frameWidth: frameWidth)
                
                Spacer()
                
                TimeStoppedView(timerInMinutes: timerInMinutes)
                
            }
            .frame(height: frameWidth)
            .padding(.top, 16)
            
        case .preparing:
                Text(koanText)
                    .font(.title)
                    .minimumScaleFactor(0.6)
                    .opacity(showKoan ? 1.0 : 0.0)
                    .padding()
            
        case .stopped:
            Text(welcomeBackText)
                .font(.title)
                .padding()
        
    }
    }
}

#Preview {
    IslandExpandedBottomView(timerStatus: .running, targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, welcomeBackText: "Welcome", koanText: "some koan", showKoan: true, frameWidth: 50)
}
