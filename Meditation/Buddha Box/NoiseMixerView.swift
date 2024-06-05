//
//  NoiseMixerView.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import SwiftUI

struct NoiseMixerView: View {
    @ObservedObject var audioManager: AudioManager
    
    @State private var highPassFilter = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 23) {
                
                Text("Brown Noise")
                Slider(value: $audioManager.soundData.brownianAmplitude, in: 0...1)
                
                Text("Pink Noise")
                Slider(value: $audioManager.soundData.pinkAmplitude, in: 0...1)
                
                Text("White Noise")
                Slider(value: $audioManager.soundData.whiteAmplitude, in: 0...1)
                
                Text("Wav Loop")
                Slider(value: $audioManager.soundData.looper1Amplitude, in: 0...1)
                Text(String(format: "%.1f", audioManager.soundData.looper1Amplitude))
                    .monospacedDigit()
                
                                Text("Shift")
                                Slider(value: $audioManager.soundData.looper1Shift, in: -12...12)
                Text(String(format: "%.1f", audioManager.soundData.looper1Shift))
                    .monospacedDigit()
                            


                
                Text("Ladder Filter Cutoff Frequency")
                Slider(value: $audioManager.filterData.logMoogCutoff, in: log10(20)...log10(20000))
                Text(String(format: "%.0f", audioManager.filterData.moogCutoff))
                    .monospacedDigit()
                
                Text("Ladder Filter Resonance")
                Slider(value: $audioManager.filterData.moogResonance, in: 0...1)
                Text(String(format: "%.1f", audioManager.filterData.moogResonance))
                    .monospacedDigit()
                
                Toggle("High Pass", isOn: $highPassFilter)
                    .onChange(of: highPassFilter) {
                        if highPassFilter == true {
                            audioManager.startHighPass()
                        } else {
                            audioManager.endHighPass()
                        }
                    }
                
                if highPassFilter {
                    Text("High Pass Cutoff Frequency")
                    Slider(value: $audioManager.filterData.logHighPassCutoff, in: log10(20)...log10(20000))
                    Text(String(format: "%.0f", audioManager.filterData.highPassCutoff))
                        .monospacedDigit()
                }
                
                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.stop()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Text(audioManager.isPlaying ? "Stop" : "Play")
                        .font(.title)
                        .padding()
                        .background(audioManager.isPlaying ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        
    }
}


#Preview {
    NoiseMixerView(audioManager: AudioManager())
}
