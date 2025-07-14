//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    @ObservedObject var audioManager: AudioManager
    @StateObject private var model = AppBlockerModel()
    
    var body: some View {
        NavigationStack(path: $model.navigationPath) {
            VStack(spacing: 20) {
                HeaderView()
                
                if model.isAuthorized {
                    MainContentView(model: model)
                } else {
                    AuthorizationView(model: model)
                }
                
                Spacer()
            }
            .padding()
            .onAppear {
                model.checkAuthorizationStatus()
            }
        }
        .navigationDestination(for: String.self) { value in
            if value == "meditation" {
                MeditationView(meditationManager: meditationManager, audioManager: audioManager)
            }
        }
    }
}


#Preview {
    ContentView(meditationManager: MeditationManager(), audioManager: AudioManager())
}
