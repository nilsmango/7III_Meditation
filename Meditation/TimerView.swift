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
    
    // View Timer
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            switch meditationManager.meditationTimer.timerStatus {
            case .running:
                Text("Running")
                Text(dateToDateFormatted(from: currentDate, to: meditationManager.meditationTimer.targetDate))
                    .monospacedDigit()
                    .onReceive(timer) { input in
                        currentDate = input
                        if currentDate >= meditationManager.meditationTimer.targetDate {
                            // TODO: make alarm
                            meditationManager.meditationTimer.timerStatus = .alarm
//                            fileManager.alarm(for: dirTimer)
//                            withAnimation(.linear(duration: 4)) {
//                                numberOfShakes = 33
//                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                                numberOfShakes = 0
//                            }
                        }
                    }
                
                HStack {
                    Button(action: {
                        // TODO: stop the timer, stop the notification, make the new timerInMinutes to be the new time, have a resume button instead of pause,
                        meditationManager.meditationTimer.timerStatus = .paused
                    }, label: {
                        Label("Pause", systemImage: "pause")
                    })
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        // TODO: stop the notification
                        withAnimation {
                            meditationManager.meditationTimer.timerStatus = .stopped
                        }
                    }, label: {
                        Label("Stop", systemImage: "stop")
                    })
                    .buttonStyle(.bordered)
                }
                
            case .alarm:
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation {
                                meditationManager.meditationTimer.timerStatus = .stopped
                            }
                        }
                    }
                
            case .stopped:
                
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
                        meditationManager.startTimer()
                    }
                    
                    
                }, label: {
                    Label("Begin Meditation", systemImage: "infinity")
                })
                .buttonStyle(.bordered)
                
            case .paused:
                Text("paused")
            case .preparing:
                Text(meditationManager.koanFunc())
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationManager.meditationTimer.preparationTime)) {
                            currentDate = .now
                            withAnimation {
                                meditationManager.meditationTimer.timerStatus = .running
                            }
                        }
                    }
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
