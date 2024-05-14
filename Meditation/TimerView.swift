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
            Spacer()
            
            switch meditationManager.meditationTimer.running {
            case .running:
                Text("Running")
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Label("Pause", systemImage: "pause")
                    })
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        
                    }, label: {
                        Label("Stop", systemImage: "stop")
                    })
                    .buttonStyle(.bordered)
                }
                
            case .alarm:
                Text("Alarm")
            case .stopped:
                
                Picker("Time", selection: meditationManager.$selectedMinutes) {
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
                    Label("Start Meditation", systemImage: "infinity")
                })
                .buttonStyle(.bordered)
                
            case .paused:
                Text("paused")
            case .preparing:
                Text("Preparing (show koan)")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(meditationManager.preparationTime)) {
                            withAnimation {
                                meditationManager.meditationTimer.running = .running
                            }
                        }
                    }
                
            }
            
            Spacer()
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
