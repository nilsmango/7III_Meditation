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
    
    @State private var circleProgress = 0.0
    @State private var timer: Timer?

    private let updateInterval = 5.0
    
    var body: some View {
        ZStack {
            
            TimerCircleView(progress: circleProgress, accentColor: .accent, updateInterval: updateInterval)
                .onAppear {
                    if isRunning {
                        startTimer()
                    } else {
                        circleProgress = 0.0
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
                            circleProgress = 0.0
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
                            circleProgress = 0.0
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
    
    private func startTimer() {
        
            updateProgress()
        
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in
                if circleProgress >= 1.0 {
                    stopTimer()
                } else {
                    updateProgress()
                }
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
        
        private func updateProgress() {
            let elapsedTime = Date().timeIntervalSince(meditationManager.meditationTimer.startDate) + updateInterval
            let totalDuration = Double(meditationManager.meditationTimer.timerInMinutes * 60)
            circleProgress = elapsedTime / totalDuration
        }
}

#Preview {
    VStack {
        Spacer()
        TimerRunningView(meditationManager: MeditationManager(), isRunning: false)
        Spacer()
    }
}
