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
        NavigationStack {
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
            .navigationTitle("App Blocker")
            .onAppear {
                model.checkAuthorizationStatus()
            }
        }
    }
}


#Preview {
    ContentView(meditationManager: MeditationManager(), audioManager: AudioManager())
}
