//
//  TimerRunningView.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct TimerRunningView: View {
    @ObservedObject var meditationManager: AppBlockerModel
    
    let isRunning: Bool
    
    let halfWidth = UIScreen.main.bounds.width / 2.8
    
    private let updateInterval = 1.0
    
    var body: some View {
        ZStack {
            
            TimerCircleView(progress: meditationManager.circleProgress, accentColor: .accent, updateInterval: updateInterval)
                .onAppear {
                    if isRunning {
                        meditationManager.startStatusTimer(updateInterval: updateInterval)
                    } else {
                        meditationManager.circleProgress = 0.0
                    }
                }
            
            
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
                        .buttonStyle(CircleButtonStyle(hugeCircle: false))
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
                            // stop meditation without saving
                            meditationManager.stopMeditation(withSaving: false)
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
        TimerRunningView(meditationManager: AppBlockerModel(), isRunning: false)
        Spacer()
    }
}
