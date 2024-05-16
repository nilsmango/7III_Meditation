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
                    
                TimerRunningView(meditationManager: meditationManager, isRunning: true)

                
            case .alarm:
                    VStack {
                        Spacer()
                        Text("Welcome Back!")
                            .font(.title)
                        Spacer()
                    }
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
                Text(meditationManager.koanFunc())
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
        .animation(.easeInOut(duration: 0.7).delay(0.3), value: meditationManager.meditationTimer.timerStatus)
        .onAppear {
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    // print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            notificationCenter.delegate = meditationManager
            meditationManager.activateHealthKit()
        }
    }
}

#Preview {
    TimerView(meditationManager: MeditationManager())
}
