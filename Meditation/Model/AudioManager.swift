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
    
    var looper1Amplitude: AUValue = 0.0
    var looper1Shift: AUValue = 0.0

}

struct FilterData {
    var moogCutoff: AUValue = 20000.0
    var moogResonance: AUValue = 0.0
    var logMoogCutoff: AUValue {
            get {
                return log10(moogCutoff)
            }
            set {
                moogCutoff = pow(10, newValue)
            }
        }
    
    var highPassCutoff: AUValue = 20.0
    var logHighPassCutoff: AUValue {
            get {
                return log10(highPassCutoff)
            }
            set {
                highPassCutoff = pow(10, newValue)
            }
        }
}

class AudioManager: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var brown = BrownianNoise()
    var pink = PinkNoise()
    var white = WhiteNoise()
    var looper1: AudioPlayer!
    var looper1PitchShifter: PitchShifter!

    
    var moogLadder: MoogLadder!
    var highPass: HighPassButterworthFilter!
    
    var peakLimiter: PeakLimiter!
    var preMixer = Mixer()

    var lowpassMixer = Mixer()
    var highPassMixer = Mixer()
    var filterMix = Mixer()
    
    var mixer = Mixer()

    @Published var soundData = NoiseData() {
        didSet {
            brown.amplitude = soundData.brownianAmplitude
            pink.amplitude = soundData.pinkAmplitude
            white.amplitude = soundData.whiteAmplitude
            looper1.volume = soundData.looper1Amplitude
            looper1PitchShifter.shift = soundData.looper1Shift
        }
    }
    
    
    @Published var filterData = FilterData() {
        didSet {
            moogLadder.cutoffFrequency = filterData.moogCutoff
            moogLadder.resonance = filterData.moogResonance
            highPass.cutoffFrequency = filterData.highPassCutoff
        }
    }
    
    @Published var isPlaying = false

    init() {
        guard let fileURL = Bundle.main.url(forResource: "loop", withExtension: "aif") else {
                    fatalError("Wav file not found in bundle")
                }
        
        // buffered audio player for seamless looping (only do this for short audio loops)
        looper1 = AudioPlayer(url: fileURL, buffered: true)
        looper1.isLooping = true
 

        let pitchShifterWindowSize: AUValue = 1024.0
        let pitchShifterCrossfade: AUValue = 512.0
        
        looper1PitchShifter = PitchShifter(looper1, shift: soundData.looper1Shift, windowSize: pitchShifterWindowSize, crossfade: pitchShifterCrossfade)
        preMixer.addInput(looper1PitchShifter)
        
        brown.start()
        pink.start()
        white.start()
        
        brown.amplitude = soundData.brownianAmplitude
        pink.amplitude = soundData.pinkAmplitude
        white.amplitude = soundData.whiteAmplitude
        looper1.volume = soundData.looper1Amplitude
        preMixer.addInput(brown)
        preMixer.addInput(pink)
        preMixer.addInput(white)
        
        
        moogLadder = MoogLadder(preMixer, cutoffFrequency: filterData.moogCutoff, resonance: filterData.moogResonance)
        lowpassMixer.addInput(moogLadder)
        
        highPass = HighPassButterworthFilter(moogLadder, cutoffFrequency: filterData.highPassCutoff)
        highPassMixer.addInput(highPass)
        
        filterMix.addInput(highPassMixer)
        filterMix.addInput(lowpassMixer)
        
        peakLimiter = PeakLimiter(filterMix)
        mixer.addInput(peakLimiter)
        engine.output = mixer
        
        mixer.volume = 0.0

    }
    
    func play() {
        do {
            try engine.start()
            isPlaying = true
            looper1.play()
            fadeIn()
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }
    
    func stop() {
        self.isPlaying = false
        
        fadeOut {
            self.looper1.stop()
            self.engine.stop()
        }
    }
    
    func startHighPass() {
        filterData.highPassCutoff = 20.0
        highPassMixer.volume = 1.0
        lowpassMixer.volume = 0.0
    }
    
    func endHighPass() {
        highPassMixer.volume = 0.0
        lowpassMixer.volume = 1.0
    }
    
    private func fadeIn() {
        let steps = 100
        let duration: Double = 2.0  // Duration of the fade in seconds
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * (duration / Double(steps))) {
                let progress = Double(i) / Double(steps)
                self.mixer.volume = AUValue(pow(progress, 2.0))  // Exponential fade in
            }
        }
    }

    private func fadeOut(completion: @escaping () -> Void) {
        let steps = 100
        let duration: Double = 2.0  // Duration of the fade in seconds
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * (duration / Double(steps))) {
                let progress = Double(i) / Double(steps)
                self.mixer.volume = AUValue(pow(1.0 - progress, 2.0))  // Exponential fade out
                
                if i == steps {
                    completion()
                }
            }
        }
    }
}

