//
//  MeditationApp.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

@main
struct MeditationApp: App {
    @StateObject private var meditationManager = MeditationManager.shared
    
    // Notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some Scene {
        WindowGroup {
            ContentView(meditationManager: meditationManager)
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
                    
                    meditationManager.startupChecks()
                    
                }
        }
    }
}
