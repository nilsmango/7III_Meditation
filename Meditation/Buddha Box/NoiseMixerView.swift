//
//  NoiseMixerView.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import SwiftUI

struct NoiseMixerView: View {
    @StateObject private var audioManager = NoiseGeneratorsConductor()
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            Text("Noise Mixer")
                .font(.largeTitle)
                .padding()
            
            HStack {
                Text("Brown Noise")
                Slider(value: $audioManager.data.brownianAmplitude, in: 0...1)
            }.padding()
            
            HStack {
                Text("Pink Noise")
                Slider(value: $audioManager.data.pinkAmplitude, in: 0...1)
            }.padding()
            
            HStack {
                Text("White Noise")
                Slider(value: $audioManager.data.whiteAmplitude, in: 0...1)
            }.padding()
            
            HStack {
                            Text("Wav Loop")
                            Slider(value: $audioManager.data.wavAmplitude, in: 0...1)
                        }.padding()
            
            Button(action: {
                if isPlaying {
                    audioManager.stop()
                } else {
                    audioManager.play()
                }
                withAnimation {
                    isPlaying.toggle()
                }
            }) {
                Text(isPlaying ? "Stop" : "Play")
                    .font(.title)
                    .padding()
                    .background(isPlaying ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}


#Preview {
    NoiseMixerView()
}
