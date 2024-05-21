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
        ZStack {
            Group {
                if isRunning {
                    Text(meditationManager.meditationTimer.targetDate, style: .timer)
                } else {
                    Text(dateToDateFormatted(from: meditationManager.meditationTimer.startDate, to: meditationManager.meditationTimer.startDate.addingTimeInterval(Double(meditationManager.meditationTimer.timerInMinutes * 60))))
                }
            }
                .font(.title)
                .monospacedDigit()
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                HStack {

                    if isRunning {
                        
                        Button(action: {
                                meditationManager.pauseMeditation()
                        }, label: {
                                Text("Pause")
                                .font(.title2)
                        })
                        .buttonStyle(CircleButtonStyle())
                        .frame(minWidth: halfWidth, alignment: .center)
                        
                    Button(role: .destructive, action: {
                            meditationManager.stopMeditation()
                    }, label: {
                        Text("Stop")
                            .font(.title2)
                    })
                    .buttonStyle(CircleButtonStyle())
                    .frame(width: halfWidth, alignment: .center)
                    
                    } else {
                        Button(action: {
                                meditationManager.startMeditation()
                        }, label: {
                            Text("Resume")
                                .font(.title2)
                        })
                        .buttonStyle(CircleButtonStyle())
                        .frame(minWidth: halfWidth, alignment: .center)
                        
                        Button(role: .destructive, action: {
                                // reseting the timer
                                meditationManager.meditationTimer.timerStatus = .alarm
                        }, label: {
                            Text("Reset")
                                .font(.title2)
                        })
                        .buttonStyle(CircleButtonStyle())
                        .frame(width: halfWidth, alignment: .center)
                    }
                        
                }
                Spacer()
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
