//
//  MeditationApp.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI
import AudioKit
import AVFoundation
import StoreKit

@main
struct MeditationApp: App {
    init() {
        
            #if os(iOS)
                do {
                    Settings.bufferLength = .short
                    try AVAudioSession.sharedInstance().setPreferredIOBufferDuration(Settings.bufferLength.duration)
                    try AVAudioSession.sharedInstance().setCategory(.playAndRecord,
                                                                    options: [.defaultToSpeaker, .mixWithOthers, .allowBluetoothA2DP])
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch let err {
                    print(err)
                }
            #endif
        }
    
    @StateObject private var audioManager = AudioManager()
    
    @StateObject private var meditationManager = MeditationManager.shared
    
    // Notifications
    private let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some Scene {
        WindowGroup {
            ContentView(meditationManager: meditationManager, audioManager: audioManager)
                .onAppear {                    
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
