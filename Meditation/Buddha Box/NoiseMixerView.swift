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
                
                Text("Noise")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("Brown Noise")
                Slider(value: $audioManager.soundData.brownianAmplitude, in: 0...1)
                
                Text("Pink Noise")
                Slider(value: $audioManager.soundData.pinkAmplitude, in: 0...1)
                
                Text("White Noise")
                Slider(value: $audioManager.soundData.whiteAmplitude, in: 0...1)
                
                
                Text("Tape Loops")
                    .font(.title3)
                    .fontWeight(.bold)
                
                ForEach($audioManager.tapeMachineControls) { $tapeMachine in
                    Text(tapeMachine.fileName)
                    Slider(value: $tapeMachine.volume, in: 0...1)
                    Text(String(format: "%.1f", tapeMachine.volume))
                        .monospacedDigit()
                        
                    
                    Text("Shift")
                    Slider(value: $tapeMachine.pitchShift, in: -2400...2400)
                    Text(String(format: "%.0f", tapeMachine.pitchShift))
                        .monospacedDigit()
                    
                    Text("Speed")
                    Slider(value: $tapeMachine.variSpeed, in: 0.25...4)
                    Text(String(format: "%.2f", tapeMachine.variSpeed))
                        .monospacedDigit()
                }
                
                Text("Effects")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("VariSpeed")
                Slider(value: $audioManager.effectsData.endVariRate, in: 0.25...4)
                Text(String(format: "%.2f", audioManager.effectsData.endVariRate))
                    .monospacedDigit()
                
                Text("Distortion")
                Slider(value: $audioManager.effectsData.distortionMix, in: 0...100)
                Text(String(format: "%.0f", audioManager.effectsData.distortionMix))
                    .monospacedDigit()
                
                
                
                Text("Low Pass Filter Cutoff Frequency")
                Slider(value: $audioManager.effectsData.logMoogCutoff, in: log10(10)...log10(22050))
                Text(String(format: "%.0f", audioManager.effectsData.moogCutoff))
                    .monospacedDigit()
                
                Text("Low Pass Filter Resonance")
                Slider(value: $audioManager.effectsData.moogResonance, in: 0...40)
                Text(String(format: "%.2f", audioManager.effectsData.moogResonance))
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
                    Slider(value: $audioManager.effectsData.logHighPassCutoff, in: log10(10)...log10(22050))
                    Text(String(format: "%.0f", audioManager.effectsData.highPassCutoff))
                        .monospacedDigit()
                    
                    Text("High Pass Resonance")
                    Slider(value: $audioManager.effectsData.highPassResonance, in: 0...40)
                    Text(String(format: "%.2f", audioManager.effectsData.highPassResonance))
                        .monospacedDigit()
                }
                
                
                
                Text("Delay Dry/Wet")
                Slider(value: $audioManager.effectsData.delayDryWetMix, in: 0...1)
                Text(String(format: "%.2f", audioManager.effectsData.delayDryWetMix))
                    .monospacedDigit()
                
                Text("Delay Time")
                Slider(value: Binding(
                                get: {
                                    sqrt(audioManager.effectsData.delayTime)
                                },
                                set: { newValue in
                                    audioManager.effectsData.delayTime = newValue * newValue
                                }
                            ), in: sqrt(0.001)...sqrt(5.000))
                            Text(String(format: "%.3f", audioManager.effectsData.delayTime))
                                .monospacedDigit()
                        
                
                Text("Delay Feedback")
                Slider(value: $audioManager.effectsData.delayFeedback, in: 0...1)
                Text(String(format: "%.2f", audioManager.effectsData.delayFeedback))
                    .monospacedDigit()
                
                Text("Reverb Dry/Wet")
                Slider(value: $audioManager.effectsData.reverbDryWetMix, in: 0...1)
                Text(String(format: "%.2f", audioManager.effectsData.reverbDryWetMix))
                    .monospacedDigit()
                
//                Text("Feedback")
//                Slider(value: $audioManager.effectsData.feedbackMix, in: 0...1)
//                Text(String(format: "%.2f", audioManager.effectsData.feedbackMix))
//                    .monospacedDigit()
                
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
