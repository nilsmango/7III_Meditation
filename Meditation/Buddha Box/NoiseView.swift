//
//  NoiseView.swift
//  Meditation
//
//  Created by Simon Lang on 01.06.2024.
//

import SwiftUI

struct NoiseView: View {
    @StateObject private var audioManager = AudioManager()
    @State private var lowPassActive = false
    @State private var highPassActive = false
    @State private var lowPassFrequency: Float = 1000
    @State private var highPassFrequency: Float = 500
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    audioManager.startNoise()
                }) {
                    Text("Start Noise")
                }
                
                Button(action: {
                    audioManager.stopNoise()
                }) {
                    Text("Stop Noise")
                }
            }
            
            Toggle("Low Pass Filter", isOn: $lowPassActive)
                .onChange(of: lowPassActive, {
                    audioManager.toggleLowPassFilter(lowPassActive)
                })
                
            
            Slider(value: Binding(
                get: {
                    Double(lowPassFrequency)
                },
                set: { newValue in
                    lowPassFrequency = Float(newValue)
                    audioManager.setLowPassFrequency(lowPassFrequency)
                }
            ), in: 20...20000, step: 1)
            Text("Low Pass Frequency: \(Int(lowPassFrequency)) Hz")
            
            Toggle("High Pass Filter", isOn: $highPassActive)
                .onChange(of: highPassActive, {
                    audioManager.toggleHighPassFilter(highPassActive)
                })
            
            Slider(value: Binding(
                get: {
                    Double(highPassFrequency)
                },
                set: { newValue in
                    highPassFrequency = Float(newValue)
                    audioManager.setHighPassFrequency(highPassFrequency)
                }
            ), in: 20...20000, step: 1)
            Text("High Pass Frequency: \(Int(highPassFrequency)) Hz")
        }
        .padding()
    }
}


#Preview {
    NoiseView()
}
