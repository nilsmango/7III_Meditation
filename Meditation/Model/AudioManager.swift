//
//  AudioManager.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit
struct NoiseData {
    var brownianAmplitude: AUValue = 0.0
    var pinkAmplitude: AUValue = 0.0
    var whiteAmplitude: AUValue = 0.0
    var wavAmplitude: AUValue = 0.0
}

class NoiseGeneratorsConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var brown = BrownianNoise()
    var pink = PinkNoise()
    var white = WhiteNoise()
    var player: AudioPlayer!
    var mixer = Mixer()

    @Published var data = NoiseData() {
        didSet {
            brown.amplitude = data.brownianAmplitude
            pink.amplitude = data.pinkAmplitude
            white.amplitude = data.whiteAmplitude
            player.volume = data.wavAmplitude
        }
    }

    init() {
        guard let fileURL = Bundle.main.url(forResource: "loop", withExtension: "aif") else {
                    fatalError("Wav file not found in bundle")
                }
        // buffered audioplayer for seamless looping (only do this for short audio loops)
        player = AudioPlayer(url: fileURL, buffered: true)
        player.isLooping = true
        
        mixer.addInput(brown)
        mixer.addInput(pink)
        mixer.addInput(white)
        mixer.addInput(player)

        brown.amplitude = data.brownianAmplitude
        pink.amplitude = data.pinkAmplitude
        white.amplitude = data.whiteAmplitude
        player.volume = data.wavAmplitude
        brown.start()
        pink.start()
        white.start()

        engine.output = mixer
    }
    
    func play() {
        do {
            try engine.start()
            player.play()
            fadeIn()
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }
    
    func stop() {
        fadeOut {
            self.player.stop()
            self.engine.stop()
        }
    }
    
    private func fadeIn() {
        let steps = 100
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.01) {
                self.data.brownianAmplitude = AUValue(i) / AUValue(steps)
                self.data.pinkAmplitude = AUValue(i) / AUValue(steps)
                self.data.whiteAmplitude = AUValue(i) / AUValue(steps)
                self.data.wavAmplitude = AUValue(i) / AUValue(steps)
            }
        }
    }
    
    private func fadeOut(completion: @escaping () -> Void) {
        let steps = 100
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.01) {
                self.data.brownianAmplitude = AUValue(steps - i) / AUValue(steps)
                self.data.pinkAmplitude = AUValue(steps - i) / AUValue(steps)
                self.data.whiteAmplitude = AUValue(steps - i) / AUValue(steps)
                self.data.wavAmplitude = AUValue(steps - i) / AUValue(steps)
                
                if i == steps {
                    completion()
                }
            }
        }
    }
}

