//
//  BuddhaBoxLayout.swift
//  Meditation
//
//  Created by Simon Lang on 04.10.2024.
//

import SwiftUI

struct BuddhaBoxLayout: View {
    @ObservedObject var meditationManager: AppBlockerModel
    
    @ObservedObject var audioManager: AudioManager
    
    @AppStorage("simpleBuddha") var simpleBuddha = true
    @AppStorage("noFading") var noFading = false
    
    // dial values
    @State private var brownNoiseAmplitude = 0.0
    @State private var pinkNoiseAmplitude = 0.0
    @State private var whiteNoiseAmplitude = 0.0
    
    @State private var buddhaLoopAmplitude = 0.0
    @State private var buddhaLoopShift = 50.0
    @State private var buddhaLoopSpeed = 20.0
    
    @State private var loopPlaying = 0
    
    @State private var userLoopAmplitude = 0.0
    @State private var userLoopShift = 50.0
    @State private var userLoopSpeed = 20.0
    
    @State private var buddhaVariSpeed = 20.0
    @State private var buddhaDistortion = 0.0
    @State private var buddhaLPFreq = 100.0
    @State private var buddhaLPRes = 0.0
    @State private var buddhaHPFreq = 0.0
    @State private var buddhaHPRes = 0.0
    @State private var buddhaDelayMix = 0.0
    @State private var buddhaDelayTime = 37.17
    @State private var buddhaDelayFeedback = 0.0
    @State private var buddhaReverbMix = 0.0
    
    let buttonFrameSize = CGSize(width: 60, height: 59)
    
    var body: some View {
        
        VStack(spacing: 16) {
            if simpleBuddha {
                
                HStack {
                    Spacer()
                    
                    Dial(value: .constant(0.0), dialColor: .accentColor, dialName: "Nothing", encoderText: "")
                        .opacity(0.0)
                    
                    Spacer()
                    
                    Dial(value: .constant(0.0), dialColor: .accentColor, dialName: "Nothing", encoderText: "")
                        .opacity(0.0)
                    
                    Spacer()
                    
                    Dial(value: .constant(0.0), dialColor: .accentColor, dialName: "Nothing", encoderText: "")
                        .opacity(0.0)
                    
                    Spacer()
                    
                    BuddhaBoxButton(action: {
                        simpleBuddha = false
                    }, labelText: "Maximize", isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                    
                    Spacer()
                }
//                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                BuddhaBoxButton(action: {
                    // start stop
                    switch audioManager.isPlaying {
                    case .playing:
                        audioManager.stop()
                    case .stopped:
                        audioManager.play()
                    default:
                        break
                        
                    }
                }, labelText: stateText, isFullOpacity: audioManager.isPlaying != .fadingOut, buttonFrameSize: buttonFrameSize)
                .disabled(audioManager.isPlaying == .fadingOut)
                
                Spacer()
                
                Group {
                    Dial(value: $brownNoiseAmplitude, dialColor: .accentColor, dialName: "Brown", encoderText: String(format: "%.2f", audioManager.soundData.brownianAmplitude))
                        .onChange(of: brownNoiseAmplitude) { _, _ in
                            audioManager.soundData.brownianAmplitude = Float(brownNoiseAmplitude / 100.0)
                        }
                        .onAppear {
                            brownNoiseAmplitude = Double(audioManager.soundData.brownianAmplitude * 100.0)
                        }
                    
                    Spacer()
                    
                    Dial(value: $pinkNoiseAmplitude, dialColor: .accentColor, dialName: "Pink", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                        .onChange(of: pinkNoiseAmplitude) { _, _ in
                            audioManager.soundData.pinkAmplitude = Float(pinkNoiseAmplitude / 100.0)
                        }
                        .onAppear {
                            pinkNoiseAmplitude = Double(audioManager.soundData.pinkAmplitude * 100.0)
                        }
                    Spacer()
                    
                    Dial(value: $whiteNoiseAmplitude, dialColor: .accentColor, dialName: "White", encoderText: String(format: "%.2f", audioManager.soundData.whiteAmplitude))
                        .onChange(of: whiteNoiseAmplitude) { _, _ in
                            audioManager.soundData.whiteAmplitude = Float(whiteNoiseAmplitude / 100.0)
                        }
                        .onAppear {
                            whiteNoiseAmplitude = Double(audioManager.soundData.whiteAmplitude * 100.0)
                        }
                }
                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
                
                
                Spacer()
            }
            
            // Buddha Loop
            HStack {
                Spacer()
                
                BuddhaBoxButton(action: {
                    if loopPlaying == audioManager.tapeMachineControls.count - 1 {
                        loopPlaying = 0
                    } else {
                        loopPlaying += 1
                    }
                }, labelText: "Loop " + String(loopPlaying), isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                .onChange(of: loopPlaying) { oldValue, newValue in
                    
                    if noFading {
                        buddhaLoopAmplitude = Double(audioManager.tapeMachineControls[loopPlaying].volume * 100.0)
                    } else {
                        audioManager.fadeToNextLoop(oldIndex: oldValue, newIndex: newValue)
                    }
                    
                    buddhaLoopShift = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].pitchShift), fromRange: -2400...2400, toRange: 0...100)
                    buddhaLoopSpeed = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].variSpeed), fromRange: 0.25...4, toRange: 0...100)
                }
                
                Spacer()
                
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "Volume", encoderText: String(format: "%.2f", audioManager.tapeMachineControls[loopPlaying].volume))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        audioManager.tapeMachineControls[loopPlaying].volume = Float(buddhaLoopAmplitude / 100.0)
                    }
                    .onAppear {
                        buddhaLoopAmplitude = Double(audioManager.tapeMachineControls[loopPlaying].volume * 100.0)
                    }
                
                Spacer()
                
                Dial(value: $buddhaLoopShift, resetValue: 50, dialColor: .accentColor, dialName: "Shift", encoderText: String(format: "%.1f", audioManager.tapeMachineControls[loopPlaying].pitchShift / 100.0))
                    .onChange(of: buddhaLoopShift) { _, _ in
                        audioManager.tapeMachineControls[loopPlaying].pitchShift = Float(mapRange(value: buddhaLoopShift, fromRange: 0...100, toRange: -2400...2400))
                    }
                    .onAppear {
                        buddhaLoopShift = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].pitchShift), fromRange: -2400...2400, toRange: 0...100)
                    }
                
                Spacer()
                
                Dial(value: $buddhaLoopSpeed, resetValue: 20, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.tapeMachineControls[loopPlaying].variSpeed))
                    .onChange(of: buddhaLoopSpeed) { _, _ in
                        audioManager.tapeMachineControls[loopPlaying].variSpeed = Float(mapRange(value: buddhaLoopSpeed, fromRange: 0...100, toRange: 0.25...4))
                    }
                    .onAppear {
                        buddhaLoopSpeed = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].variSpeed), fromRange: 0.25...4, toRange: 0...100)
                    }
                
                Spacer()
            }
            .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
            
            if !simpleBuddha {
                // User Loop
                HStack {
                    Spacer()
                    
                    // took out the loading of samples as it's much more fun like this.
                    BuddhaBoxButton(action: {
                        if audioManager.isRecording {
                            audioManager.stopRecording()
                            
                        } else {
                            audioManager.startRecording()
                        }
                    }, labelText: audioManager.isRecording ? "Stop" : "Record", isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                    
                    Spacer()
                    
                    Dial(value: $userLoopAmplitude, dialColor: .accentColor, dialName: "Volume", encoderText: String(format: "%.2f", audioManager.soundData.userVolume))
                        .onChange(of: userLoopAmplitude) { _, _ in
                            audioManager.soundData.userVolume = Float(userLoopAmplitude / 100.0)
                        }
                        .onAppear {
                            userLoopAmplitude = Double(audioManager.soundData.userVolume * 100.0)
                        }
                    
                    Spacer()
                    
                    Dial(value: $userLoopShift, resetValue: 50, dialColor: .accentColor, dialName: "Shift", encoderText: String(format: "%.1f", audioManager.soundData.userPitchShift / 100.0))
                        .onChange(of: userLoopShift) { _, _ in
                            audioManager.soundData.userPitchShift = Float(mapRange(value: userLoopShift, fromRange: 0...100, toRange: -2400...2400))
                        }
                        .onAppear {
                            userLoopShift = mapRange(value: Double(audioManager.soundData.userPitchShift), fromRange: -2400...2400, toRange: 0...100)
                        }
                    
                    Spacer()
                    
                    Dial(value: $userLoopSpeed, resetValue: 20, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.soundData.userVariSpeed))
                        .onChange(of: userLoopSpeed) { _, _ in
                            audioManager.soundData.userVariSpeed = Float(mapRange(value: userLoopSpeed, fromRange: 0...100, toRange: 0.25...4))
                        }
                        .onAppear {
                            userLoopSpeed = mapRange(value: Double(audioManager.soundData.userVariSpeed), fromRange: 0.25...4, toRange: 0...100)
                        }
                    
                    Spacer()
                }
                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
                
                Spacer()
                
                // Master Effects
                HStack {
                    Group {
                        
                    Spacer()
                    
                    Dial(value: $buddhaVariSpeed, resetValue: 20, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.effectsData.endVariRate))
                        .onChange(of: buddhaVariSpeed) { _, _ in
                            audioManager.effectsData.endVariRate = Float(mapRange(value: buddhaVariSpeed, fromRange: 0...100, toRange: 0.25...4))
                        }
                        .onAppear {
                            buddhaVariSpeed = mapRange(value: Double(audioManager.effectsData.endVariRate), fromRange: 0.25...4, toRange: 0...100)
                        }
                    
                    Spacer()
                    
                    Dial(value: $buddhaDistortion, dialColor: .accentColor, dialName: "Distortion", encoderText: String(format: "%.2f", audioManager.effectsData.distortionMix / 100.0))
                        .onChange(of: buddhaDistortion) { _, _ in
                            audioManager.effectsData.distortionMix = Float(buddhaDistortion)
                        }
                        .onAppear {
                            buddhaDistortion = Double(audioManager.effectsData.distortionMix)
                        }
                    
                    Spacer()
                }
                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
                    
                    BuddhaBoxButton(action: {
                        noFading.toggle()
                    }, labelText: noFading ? "No Fade" : "Loop Fade", isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                    
                    Spacer()
                    
                    BuddhaBoxButton(action: {
                        simpleBuddha = true
                    }, labelText: "Simplify", isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                    
                    Spacer()
                    
                }
                
                
                
                HStack {
                    Spacer()
                    Dial(value: $buddhaLPFreq, resetValue: 100, dialColor: .accentColor, dialName: "LP Freq", encoderText: {
                        let frequency = pow(10, Double(audioManager.effectsData.logMoogCutoff))
                        if frequency < 1000 {
                            return String(format: "%.0f", frequency)
                        } else if frequency < 10000 {
                            return String(format: "%.2fk", frequency / 1000)
                        } else {
                            return String(format: "%.1fk", frequency / 1000)
                        }
                    }())
                    .onChange(of: buddhaLPFreq) { _, _ in
                        audioManager.effectsData.logMoogCutoff = Float(mapRange(value: buddhaLPFreq, fromRange: 0...100, toRange: log10(10)...log10(22050)))
                    }
                    .onAppear {
                        buddhaLPFreq = mapRange(value: Double(audioManager.effectsData.logMoogCutoff), fromRange: log10(10)...log10(22050), toRange: 0...100)
                    }
                    
                    Spacer()
                    
                    Dial(value: $buddhaLPRes, dialColor: .accentColor, dialName: "LP Res", encoderText: String(format: "%.1f", audioManager.effectsData.moogResonance))
                        .onChange(of: buddhaLPRes) { _, _ in
                            // 0...40
                            audioManager.effectsData.moogResonance = Float(mapRange(value: buddhaLPRes, fromRange: 0...100, toRange: 0...40))
                        }
                        .onAppear {
                            buddhaLPRes = mapRange(value: Double(audioManager.effectsData.moogResonance), fromRange: 0...40, toRange: 0...100)
                        }
                    
                    Spacer()
                    
                    Dial(value: $buddhaHPFreq, resetValue: 0, dialColor: .accentColor, dialName: "HP Freq", encoderText: {
                        let frequency = pow(10, Double(audioManager.effectsData.logHighPassCutoff))
                        if frequency < 1000 {
                            return String(format: "%.0f", frequency)
                        } else if frequency < 10000 {
                            return String(format: "%.2fk", frequency / 1000)
                        } else {
                            return String(format: "%.1fk", frequency / 1000)
                        }
                    }())
                    .onChange(of: buddhaHPFreq) { _, _ in
                        audioManager.effectsData.logHighPassCutoff = Float(mapRange(value: buddhaHPFreq, fromRange: 0...100, toRange: log10(10)...log10(22050)))
                    }
                    .onAppear {
                        audioManager.startHighPass()
                        buddhaHPFreq = mapRange(value: Double(audioManager.effectsData.logHighPassCutoff), fromRange: log10(10)...log10(22050), toRange: 0...100)
                    }
                    
                    Spacer()
                    
                    Dial(value: $buddhaHPRes, dialColor: .accentColor, dialName: "HP Res", encoderText: String(format: "%.1f", audioManager.effectsData.highPassResonance))
                        .onChange(of: buddhaHPRes) { _, _ in
                            // 0...40
                            audioManager.effectsData.highPassResonance = Float(mapRange(value: buddhaHPRes, fromRange: 0...100, toRange: 0...40))
                        }
                        .onAppear {
                            buddhaHPRes = mapRange(value: Double(audioManager.effectsData.highPassResonance), fromRange: 0...40, toRange: 0...100)
                        }
                    
                    Spacer()
                }
                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
                
                HStack {
                    Spacer()
                    
                    Dial(value: $buddhaDelayMix, dialColor: .accentColor, dialName: "Delay Mix", encoderText: String(format: "%.2f", audioManager.effectsData.delayDryWetMix))
                        .onChange(of: buddhaDelayMix) { _, _ in
                            audioManager.effectsData.delayDryWetMix = Float(buddhaDelayMix / 100.0)
                        }
                        .onAppear {
                            buddhaDelayMix = Double(audioManager.effectsData.delayDryWetMix * 100.0)
                        }
                    
                    Spacer()
                    
                    Dial(
                        value: $buddhaDelayTime,
                        resetValue: 37.17,
                        dialColor: .accentColor,
                        dialName: "Time",
                        encoderText: String(format: "%.3f", audioManager.effectsData.delayTime)
                    )
                    .onChange(of: buddhaDelayTime) { _, _ in
                        // Map Dial value (0-100) to sqrt(0.001) - sqrt(5.0), then square it for delayTime
                        let mappedValue = mapRange(
                            value: buddhaDelayTime,
                            fromRange: 0...100,
                            toRange: sqrt(0.001)...sqrt(5.000)
                        )
                        audioManager.effectsData.delayTime = Float(mappedValue * mappedValue)
                        
                    }
                    .onAppear {
                        // Map delayTime (already squared) to Dial value (0-100)
                        let sqrtDelayTime = sqrt(Double(audioManager.effectsData.delayTime))
                        buddhaDelayTime = mapRange(
                            value: sqrtDelayTime,
                            fromRange: sqrt(0.001)...sqrt(5.000),
                            toRange: 0...100
                        )
                    }
                    
                    Spacer()
                    
                    Dial(value: $buddhaDelayFeedback, dialColor: .accentColor, dialName: "Feedback", encoderText: String(format: "%.2f", audioManager.effectsData.delayFeedback))
                        .onChange(of: buddhaDelayFeedback) { _, _ in
                            audioManager.effectsData.delayFeedback = Float(buddhaDelayFeedback / 100.0)
                        }
                        .onAppear {
                            buddhaDelayFeedback = Double(audioManager.effectsData.delayFeedback * 100.0)
                        }
                    
                    Spacer()
                    
                    Dial(value: $buddhaReverbMix, resetValue: 0, dialColor: .accentColor, dialName: "Reverb Mix", encoderText: String(format: "%.2f", audioManager.effectsData.reverbDryWetMix))
                        .onChange(of: buddhaReverbMix) { _, _ in
                            audioManager.effectsData.reverbDryWetMix = Float(buddhaReverbMix / 100.0)
                        }
                        .onAppear {
                            buddhaReverbMix = Double(audioManager.effectsData.reverbDryWetMix * 100.0)
                        }
                    
                    Spacer()
                }
                .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
            }
            if simpleBuddha {
                Spacer()
            }
            Spacer()
        }
        .padding(.vertical)
        .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
        .defersSystemGestures(on: .all)
    }
    
    var stateText: String {
        switch audioManager.isPlaying {
        case .playing:
            return "Stop"
        case .fadingOut:
            return "Fading"
        case .stopped:
            return "Start"
        }
    }
}

#Preview {
    BuddhaBoxLayout(meditationManager: AppBlockerModel(), audioManager: AudioManager())
}
