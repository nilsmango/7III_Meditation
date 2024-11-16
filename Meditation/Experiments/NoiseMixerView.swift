//
//  NoiseMixerView.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import SwiftUI

// Prototype with also loading of samples
struct NoiseMixerView: View {
    @ObservedObject var audioManager: AudioManager
    
    @State private var highPassFilter = false
    @State private var isRecording = false
    @State private var showFilePicker = false
    
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
                
                
                Text("User Loop")
                    .font(.title3)
                    .fontWeight(.bold)
                
                if audioManager.userSelectedPlayer != nil {
                                Text("User Selected Audio")
                    Slider(value: $audioManager.soundData.userVolume, in: 0...1)
                                Text(String(format: "%.1f", audioManager.soundData.userVolume))
                                    .monospacedDigit()
                            }
                            
                            HStack {
                                Button(action: {
                                    showFilePicker.toggle()
                                }) {
                                    Text("Select Audio File")
                                }
                                .fileImporter(
                                    isPresented: $showFilePicker,
                                    allowedContentTypes: [.audio],
                                    onCompletion: { result in
                                        switch result {
                                        case .success(let url):
                                            _ = url.startAccessingSecurityScopedResource()
                                            audioManager.loadUserSelectedAudio(url: url)
                                        case .failure(let error):
                                            print("Error selecting file: \(error.localizedDescription)")
                                        }
                                    }
                                )
                                
                                if audioManager.isRecording {
                                    Button(action: {
                                        audioManager.stopRecording()
                                    }) {
                                        Text("Stop Recording")
                                            .foregroundColor(.red)
                                    }
                                } else {
                                    Button(action: {
                                        audioManager.startRecording()
                                    }) {
                                        Text("Start Recording")
                                    }
                                }
                            }
                
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
                    switch audioManager.isPlaying {
                    case .playing:
                        audioManager.stop()
                    case .stopped:
                        audioManager.play()
                    default:
                        break
                    }
                    
                }) {
                    Text(stateText)
                        .font(.title)
                        .padding()
                        .background(stateBackground)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        
    }
    
    var stateText: String {
            switch audioManager.isPlaying {
            case .playing:
                return "Stop"
            case .fadingOut:
                return "Fading Out"
            case .stopped:
                return "Play"
            }
        }
    
    var stateBackground: Color {
        switch audioManager.isPlaying {
        case .playing:
                .red
        case .fadingOut:
            .orange
        case .stopped:
            .green
        }
    }
}


#Preview {
    NoiseMixerView(audioManager: AudioManager())
}
