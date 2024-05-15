//
//  TimerView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var meditationManager: MeditationManager
        
    // Notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            switch meditationManager.meditationTimer.timerStatus {
            case .running:
                Group {
                    Text("Running")
                    
                    Text(meditationManager.meditationTimer.timeLeft)
                        .monospacedDigit()
                    
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                meditationManager.pauseMeditation()
                            }
                        }, label: {
                            Label("Pause", systemImage: "pause")
                        })
                        .buttonStyle(.bordered)
                        
                        Button(role: .destructive, action: {
                            
                            withAnimation {
                                meditationManager.stopMeditation()
                            }
                        }, label: {
                            Label("Stop", systemImage: "xmark")
                        })
                        .buttonStyle(.bordered)
                    }
                }
                .transition(.opacity)
                
            case .alarm:
                Group {
                    VStack {
                        Spacer()
                        Text("Welcome Back!")
                        Spacer()
                    }
                    .onTapGesture {
                        withAnimation {
                            meditationManager.meditationTimer.timerStatus = .stopped
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                meditationManager.meditationTimer.timerStatus = .stopped
                            }
                        }
                    }
                    
                }
                .transition(.opacity)
            case .stopped:
                
                Group {
                    Picker("Time", selection: $meditationManager.meditationTimer.timerInMinutes) {
                        ForEach(1...300, id: \.self) { minutes in
                            Text("\(minutes) \(minutes == 1 ? "Minute" : "Minutes")")
                                .foregroundColor(minutes % 60 == 0 ? .blue : .primary)
                                .font(minutes % 60 == 0 ? .headline : .body)
                        }
                    }
                
                // .pickerStyle(WheelPickerStyle())
                
                Button(action: {
                    
                    withAnimation {
                        meditationManager.startMeditation()
                    }
                    
                }, label: {
                    Label("Begin Meditation", systemImage: "infinity")
                })
                .buttonStyle(.bordered)
            }
                .transition(.opacity)
            case .paused:
                Group {
                    Text("Running")
                    
                    Text(meditationManager.meditationTimer.timeLeft)
                        .monospacedDigit()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                meditationManager.startMeditation()
                            }
                        }, label: {
                            Label("Resume", systemImage: "arrow.clockwise")
                        })
                        .buttonStyle(.bordered)
                        
                        Button(role: .destructive, action: {
                            
                            withAnimation {
                                // reseting the timer
                                meditationManager.meditationTimer.timerStatus = .alarm
                            }
                        }, label: {
                            Label("Stop", systemImage: "xmark")
                        })
                        .buttonStyle(.bordered)
                    }
                }
                .transition(.opacity)
            case .preparing:
                Text(meditationManager.koanFunc())
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationManager.meditationTimer.preparationTime)) {
                            withAnimation {
                                meditationManager.meditationTimer.timerStatus = .running
                            }
                        }
                    }
                    .transition(.opacity)
            }
            
            Spacer(minLength: 0)
        }
        .onAppear {
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    // print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            notificationCenter.delegate = meditationManager
        }
    }
}

#Preview {
    TimerView(meditationManager: MeditationManager())
}
