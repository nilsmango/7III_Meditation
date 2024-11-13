//
//  BuddhaBoxLayout.swift
//  Meditation
//
//  Created by Simon Lang on 04.10.2024.
//

import SwiftUI

struct BuddhaBoxLayout: View {
    @ObservedObject var audioManager: AudioManager
    // dial values
    @State private var whiteNoiseAmplitude = 0.0
    
    @State private var isPlaying: Bool = false
    var body: some View {
        
        // TODO: if end values are not from 0...100 then calculate it separately, don't change the dial values.
        // TODO: maybe no dial names? makes it more fun?
        Dial(value: $whiteNoiseAmplitude, dialColor: .accentColor, dialName: "White Noise", encoderText: String(format: "%.2f", audioManager.soundData.whiteAmplitude))
            .onChange(of: whiteNoiseAmplitude) { _, _ in
                audioManager.soundData.whiteAmplitude = Float(whiteNoiseAmplitude / 100.0)
            }
        
        Button(role: .destructive, action: {
            // start stop
            if isPlaying {
                
            }
        }, label: {
            Text(isPlaying ? "Stop" : "Play")
                .font(.title2)
        })
        .buttonStyle(CircleButtonStyle())
        .onAppear {
            whiteNoiseAmplitude = Double(audioManager.soundData.whiteAmplitude / 100.0)
        }

    }
}

#Preview {
    BuddhaBoxLayout(audioManager: AudioManager())
}
