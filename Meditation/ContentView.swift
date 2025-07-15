//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: AppBlockerModel
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        NavigationStack(path: $model.navigationPath) {
            Group {
                if model.isAuthorized {
                    MainContentView(model: model)
                } else {
                    AuthorizationView(model: model)
                }
            }
            .onAppear {
                model.checkAuthorizationStatus()
            }
            .navigationDestination(for: String.self) { value in
                if value == "meditation" {
                    MeditationView(meditationManager: model, audioManager: audioManager)
                } else if value == "app-blocker" {
                    AppBlockerView(model: model)
                }
            }
        }
    }
}


#Preview {
    ContentView(model: AppBlockerModel(), audioManager: AudioManager())
}
