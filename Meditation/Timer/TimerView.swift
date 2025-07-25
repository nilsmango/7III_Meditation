//
//  TimerView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var meditationManager: TheModel

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            switch meditationManager.meditationTimer.timerStatus {
            case .running:
                    
                TimerRunningView(meditationManager: meditationManager, isRunning: true)

                
            case .alarm:
                    
                Text(meditationManager.welcomeMessage)
                    .font(.title)
                    .onTapGesture {
                        meditationManager.meditationTimer.timerStatus = .stopped
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            meditationManager.meditationTimer.timerStatus = .stopped
                        }
                    }

            case .stopped:
                
                TimerStoppedView(meditationManager: meditationManager)
                    

            case .paused:
                    
                TimerRunningView(meditationManager: meditationManager, isRunning: false)

            case .preparing:
                Text(meditationManager.meditationTimer.showKoan ? meditationManager.koanOfTheDay : "")
                    .font(.title)
                    .padding(32)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationManager.meditationTimer.preparationTime)) {
                                meditationManager.meditationTimer.timerStatus = .running
                        }
                    }
            }
            
            Spacer(minLength: 0)
        }
        .animation(.easeInOut(duration: 1.0).delay(0.3), value: meditationManager.meditationTimer.timerStatus)
    }
}

#Preview {
    TimerView(meditationManager: TheModel())
}
