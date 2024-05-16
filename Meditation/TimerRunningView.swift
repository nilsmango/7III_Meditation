//
//  TimerRunningView.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct TimerRunningView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    let isRunning: Bool
    
    let halfWidth = UIScreen.main.bounds.width / 2.8
    
    var body: some View {
        Spacer()
        
        Text(meditationManager.meditationTimer.timeLeft)
            .font(.title)
            .monospacedDigit()
        
        Spacer()
        
        HStack {

            if isRunning {
                
                Button(action: {
                        meditationManager.pauseMeditation()
                }, label: {
                        Text("Pause")
                })
                .buttonStyle(CircleButtonStyle())
                .frame(minWidth: halfWidth, alignment: .center)
                
            Button(role: .destructive, action: {
                    meditationManager.stopMeditation()
            }, label: {
                Text("Stop")
            })
            .buttonStyle(CircleButtonStyle())
            .frame(width: halfWidth, alignment: .center)
            
            } else {
                Button(action: {
                        meditationManager.startMeditation()
                }, label: {
                    Text("Resume")
                })
                .buttonStyle(CircleButtonStyle())
                .frame(minWidth: halfWidth, alignment: .center)
                
                Button(role: .destructive, action: {
                        // reseting the timer
                        meditationManager.meditationTimer.timerStatus = .alarm
                }, label: {
                    Text("Reset")
                })
                .buttonStyle(CircleButtonStyle())
                .frame(width: halfWidth, alignment: .center)
            }
                
        }
    }
}

#Preview {
    VStack {
        Spacer()
        TimerRunningView(meditationManager: MeditationManager(), isRunning: false)
        Spacer()
    }
}
