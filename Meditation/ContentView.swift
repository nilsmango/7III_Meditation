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
            .navigationDestination(for: String.self) { value in
                if value == "meditation" {
                    MeditationView(meditationManager: model, audioManager: audioManager)
                }
            }
        }
    }
}


#Preview {
    ContentView(model: AppBlockerModel(), audioManager: AudioManager())
}
