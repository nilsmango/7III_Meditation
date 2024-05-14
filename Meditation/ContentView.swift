//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    var body: some View {
        VStack {
            TimerView(meditationManager: meditationManager)
        }
        .padding()
    }
}

#Preview {
    ContentView(meditationManager: MeditationManager())
}
