//
//  BuddhaBoxView.swift
//  Meditation
//
//  Created by Simon Lang on 04.06.2024.
//

import SwiftUI

struct BuddhaBoxView: View {
    @ObservedObject var audioManager: AudioManager
    
    var body: some View {
        NoiseMixerView(audioManager: audioManager)
            .background(.customGray)
            .navigationTitle("Buddha Box")
    }
}

#Preview {
    NavigationStack {
        BuddhaBoxView(audioManager: AudioManager())
    }
}
