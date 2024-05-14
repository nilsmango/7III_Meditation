//
//  MeditationApp.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

@main
struct MeditationApp: App {
    @StateObject private var meditationManager = MeditationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(meditationManager: meditationManager)
        }
    }
}
