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
    
    @State private var isPlaying: Bool = false
    
    // dial values
    @State private var brownNoiseAmplitude = 0.0
    @State private var pinkNoiseAmplitude = 0.0
    @State private var whiteNoiseAmplitude = 0.0
    
    @State private var buddhaLoopAmplitude = 0.0
    @State private var buddhaLoopShift = 50.0
    @State private var buddhaLoopSpeed = 1.0
    
    @State private var loopPlaying = 0
    let numberOfLoops = 4
    
    
    let buttonFrameSize = CGSize(width: 50, height: 59)
    var body: some View {
        
        
        VStack {
            HStack {
                Spacer()
                
                BuddhaBoxButton(action: {
                    // start stop
                    if isPlaying {
                        
                    } else {
                        
                    }
                    
                    isPlaying.toggle()
                }, labelText: isPlaying ? "On" : "Off", isFullOpacity: isPlaying, buttonFrameSize: buttonFrameSize)
                
                
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
                .opacity(isPlaying ? 1.0 : 0.5)
                
                
                Spacer()
            }
            
            HStack {
                // TODO: User Loop
                Text("User Loop Here")
            }
            .opacity(isPlaying ? 1.0 : 0.5)
            
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
                .onChange(of: loopPlaying) { _, _ in
                    buddhaLoopAmplitude = Double(audioManager.tapeMachineControls[loopPlaying].volume * 100.0)
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
                // TODO: finish it 0.25...4
                Dial(value: $buddhaLoopSpeed, resetValue: 20, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.tapeMachineControls[loopPlaying].variSpeed))
                    .onChange(of: buddhaLoopSpeed) { _, _ in
                        audioManager.tapeMachineControls[loopPlaying].variSpeed = Float(mapRange(value: buddhaLoopSpeed, fromRange: 0...100, toRange: 0.25...4))
                    }
                    .onAppear {
                        buddhaLoopSpeed = mapRange(value: Double(audioManager.tapeMachineControls[loopPlaying].variSpeed), fromRange: 0.25...4, toRange: 0...100)
                    }
                
                Spacer()
            }
            .opacity(isPlaying ? 1.0 : 0.5)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "VariSpeed", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        //                        audioManager.soundData.pinkAmplitude = Float(buddhaLoopAmplitude / 100.0)
                    }
                
                Spacer()
                
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "Distortion", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        //                        audioManager.soundData.pinkAmplitude = Float(buddhaLoopAmplitude / 100.0)
                    }
                
                Spacer()
                
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "LP Freq", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        //                        audioManager.soundData.pinkAmplitude = Float(buddhaLoopAmplitude / 100.0)
                    }
                
                Spacer()
                
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "LP Res", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        //                        audioManager.soundData.pinkAmplitude = Float(buddhaLoopAmplitude / 100.0)
                    }
                
                Spacer()
            }
            .opacity(isPlaying ? 1.0 : 0.5)
            
            Spacer()
        }
        .padding(.vertical)
        .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
        

    }
}

#Preview {
    BuddhaBoxLayout(meditationManager: MeditationManager(), audioManager: AudioManager())
}
