//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    // Notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        NavigationLink(destination: StatisticsView(meditationManager: meditationManager)) {
                            StreakButton(streakNumber: meditationManager.meditationTimer.statistics.currentStreak)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: OptionsView(meditationManager: meditationManager)) {
                            Label("Options", systemImage: "ellipsis.circle.fill")
                                .font(.title.weight(.ultraLight))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blackWhite, .accent)
                                .labelStyle(.iconOnly)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                        }
                    }
                    
                    Spacer()
                    
                }
                TimerView(meditationManager: meditationManager)
            }
            .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
        }
        .onAppear {
            meditationManager.checkStatusOfTimer()
            
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    // print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            notificationCenter.delegate = meditationManager
            
            meditationManager.activateHealthKitGetMeditationSessions()
            
        }
        
    }
}

#Preview {
    ContentView(meditationManager: MeditationManager())
}
