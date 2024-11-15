//
//  BuddhaBoxLayout.swift
//  Meditation
//
//  Created by Simon Lang on 04.10.2024.
//

import SwiftUI

struct BuddhaBoxLayout: View {
    @ObservedObject var audioManager: AudioManager
    
    @State private var isPlaying: Bool = false
    
    // dial values
    @State private var brownNoiseAmplitude = 0.0
    @State private var pinkNoiseAmplitude = 0.0
    @State private var whiteNoiseAmplitude = 0.0
    
    @State private var buddhaLoopAmplitude = 0.0
    
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
                
                Dial(value: $brownNoiseAmplitude, dialColor: .accentColor, dialName: "Brown Noise", encoderText: String(format: "%.2f", audioManager.soundData.brownianAmplitude))
                    .onChange(of: brownNoiseAmplitude) { _, _ in
                        audioManager.soundData.brownianAmplitude = Float(brownNoiseAmplitude / 100.0)
                    }
                
                Spacer()
                
                Dial(value: $pinkNoiseAmplitude, dialColor: .accentColor, dialName: "Pink Noise", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: pinkNoiseAmplitude) { _, _ in
                        audioManager.soundData.pinkAmplitude = Float(pinkNoiseAmplitude / 100.0)
                    }
                
                Spacer()
                
                Dial(value: $whiteNoiseAmplitude, dialColor: .accentColor, dialName: "White Noise", encoderText: String(format: "%.2f", audioManager.soundData.whiteAmplitude))
                    .onChange(of: whiteNoiseAmplitude) { _, _ in
                        audioManager.soundData.whiteAmplitude = Float(whiteNoiseAmplitude / 100.0)
                    }
                
            }
            
            HStack {
                // TODO: User Loop
                Text("User Loop Here")
            }
            
            // Buddha Loop
            HStack {
                Spacer()
                
                BuddhaBoxButton(action: {
                    if loopPlaying == numberOfLoops {
                        loopPlaying = 0
                    } else {
                        loopPlaying += 1
                    }
                }, labelText: String(loopPlaying), isFullOpacity: true, buttonFrameSize: buttonFrameSize)
                
                Spacer()
                Spacer()
                
                // TODO: make this into the model instead of the tapemachine I guess?
                Dial(value: $buddhaLoopAmplitude, dialColor: .accentColor, dialName: "Volume", encoderText: String(format: "%.2f", audioManager.soundData.pinkAmplitude))
                    .onChange(of: buddhaLoopAmplitude) { _, _ in
                        //                        audioManager.soundData.pinkAmplitude = Float(buddhaLoopAmplitude / 100.0)
                    }
            }
            
            Spacer()
        }
        .padding()
        
        .onAppear {
            brownNoiseAmplitude = Double(audioManager.soundData.brownianAmplitude / 100.0)
            pinkNoiseAmplitude = Double(audioManager.soundData.pinkAmplitude / 100.0)
            whiteNoiseAmplitude = Double(audioManager.soundData.whiteAmplitude / 100.0)
        }

    }
}

#Preview {
    BuddhaBoxLayout(audioManager: AudioManager())
}
