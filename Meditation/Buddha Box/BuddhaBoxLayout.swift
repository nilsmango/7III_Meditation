//
//  BuddhaBoxLayout.swift
//  Meditation
//
//  Created by Simon Lang on 04.10.2024.
//

import SwiftUI

struct BuddhaBoxLayout: View {
    @ObservedObject var meditationManager: MeditationManager

    @ObservedObject var audioManager: AudioManager
        
    // dial values
    @State private var brownNoiseAmplitude = 0.0
    @State private var pinkNoiseAmplitude = 0.0
    @State private var whiteNoiseAmplitude = 0.0
    
    @State private var buddhaLoopAmplitude = 0.0
    @State private var buddhaLoopShift = 50.0
    @State private var buddhaLoopSpeed = 20.0
    
    @State private var loopPlaying = 0
    let numberOfLoops = 4
    
    @State private var buddhaVariSpeed = 20.0
    @State private var buddhaDistortion = 0.0
    @State private var buddhaLPFreq = 100.0
    @State private var buddhaLPRes = 0.0
    @State private var buddhaHPFreq = 0.0
    
    let buttonFrameSize = CGSize(width: 50, height: 59)
    var body: some View {
        
        
        VStack {
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
                }, labelText: stateText, isFullOpacity: audioManager.isPlaying == .playing, buttonFrameSize: buttonFrameSize)
                .disabled(audioManager.isPlaying == .fadingOut)
                
                
                Spacer()
                Spacer()
                // TODO: if end values are not from 0...100 then calculate it separately, don't change the dial values.
                // TODO: maybe no dial names? makes it more fun?
                
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
            
            HStack {
                // TODO: User Loop
                Text("User Loop Here")
            }
            .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
            
            // Buddha Loop
            HStack {
                Spacer()
                
                BuddhaBoxButton(action: {
                    if loopPlaying == numberOfLoops - 1 {
                        loopPlaying = 0
                    } else {
                        loopPlaying += 1
                    }
                }, labelText: "Loop " + String(loopPlaying), isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                .onChange(of: loopPlaying) { oldValue, newValue in
                    audioManager.fadeToNextLoop(oldIndex: oldValue, newIndex: newValue)
                    
                    buddhaLoopShift = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].pitchShift), fromRange: -2400...2400, toRange: 0...100)
                    buddhaLoopSpeed = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].variSpeed), fromRange: 0.25...4, toRange: 0...100)
                }
                
                Spacer()
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
            
            Spacer()
            
            HStack {
                Spacer()
                
                Dial(value: $buddhaVariSpeed, resetValue: 20, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.effectsData.endVariRate))
                    .onChange(of: buddhaVariSpeed) { _, _ in
                        audioManager.effectsData.endVariRate = Float(mapRange(value: buddhaVariSpeed, fromRange: 0...100, toRange: 0.25...4))
                    }
                    .onAppear {
                        buddhaVariSpeed = mapRange(value: Double(audioManager.effectsData.endVariRate), fromRange: 0.25...4, toRange: 0...100)
                    }
                
                Spacer()
                
                Dial(value: $buddhaDistortion, dialColor: .accentColor, dialName: "Distortion", encoderText: String(format: "%.2f", audioManager.effectsData.distortionMix))
                    .onChange(of: buddhaDistortion) { _, _ in
                        audioManager.effectsData.distortionMix = Float(buddhaDistortion / 100.0)
                    }
                    .onAppear {
                        buddhaDistortion = Double(audioManager.effectsData.distortionMix * 100.0)
                    }
                
                Spacer()
                // audioManager.effectsData.logMoogCutoff, in: log10(10)...log10(22050)
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
            }
            .opacity(audioManager.isPlaying == .playing ? 1.0 : 0.5)
            
            Spacer()
        }
        .padding(.vertical)
        .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
        

    }
    
    var stateText: String {
            switch audioManager.isPlaying {
            case .playing:
                return "On"
            case .fadingOut:
                return "Fading"
            case .stopped:
                return "Off"
            }
        }
}

#Preview {
    BuddhaBoxLayout(meditationManager: MeditationManager(), audioManager: AudioManager())
}
