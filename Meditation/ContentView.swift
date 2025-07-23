//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: TheModel
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        NavigationStack(path: $model.navigationPath) {
            MainContentView(model: model)
                .onAppear {
                    model.checkAuthorizationStatus()
                }
                .navigationDestination(for: AppDestination.self) { value in
                    if !model.isAuthorized {
                        AuthorizationView(model: model)
                    } else if value == .meditation {
                        MeditationView(meditationManager: model, audioManager: audioManager)
                    } else if value == .appBlocker {
                        AppBlockerView(model: model)
                    }
                }
        }
    }
}


#Preview {
    ContentView(model: TheModel(), audioManager: AudioManager())
}
