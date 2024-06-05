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

struct EffectsData {
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
    
    var reverbDryWetMix: AUValue = 0.0
    var delayFeedback: AUValue = 0.0
    var delayTime: AUValue = 0.001
    var delayDryWetMix: AUValue = 0.0
}

class AudioManager: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var brown = BrownianNoise()
    var pink = PinkNoise()
    var white = WhiteNoise()
    var looper1: AudioPlayer!
    var looper1PitchShifter: TimePitch!

    
    var moogLadder: MoogLadder!
    var highPass: HighPassButterworthFilter!
    var delay: VariableDelay!
    var delayWet = Mixer()
    var delayDry = Mixer()
    var delayMix = Mixer()
    
    var reverb: ZitaReverb!
    
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
            looper1PitchShifter.pitch = soundData.looper1Shift
        }
    }
    
    
    @Published var effectsData = EffectsData() {
        didSet {
            moogLadder.cutoffFrequency = effectsData.moogCutoff
            moogLadder.resonance = effectsData.moogResonance
            highPass.cutoffFrequency = effectsData.highPassCutoff
            delay.feedback = effectsData.delayFeedback
            delay.time = effectsData.delayTime
            delayWet.volume = effectsData.delayDryWetMix
            delayDry.volume = abs(effectsData.delayDryWetMix - 1.0)
            reverb.dryWetMix = effectsData.reverbDryWetMix
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
        
        looper1PitchShifter = TimePitch(looper1, pitch: soundData.looper1Shift)
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
        
        
        moogLadder = MoogLadder(preMixer, cutoffFrequency: effectsData.moogCutoff, resonance: effectsData.moogResonance)
        lowpassMixer.addInput(moogLadder)
        
        highPass = HighPassButterworthFilter(moogLadder, cutoffFrequency: effectsData.highPassCutoff)
        highPassMixer.addInput(highPass)
        
        filterMix.addInput(highPassMixer)
        filterMix.addInput(lowpassMixer)
        
        delay = VariableDelay(filterMix, time: effectsData.delayTime, feedback: effectsData.delayFeedback, maximumTime: 5.0)
        
        delayWet.addInput(delay)
        delayDry.addInput(filterMix)
        
        delayMix.addInput(delayWet)
        delayMix.addInput(delayDry)
        
        reverb = ZitaReverb(delayMix,
                                    predelay: 45.0,
                                    crossoverFrequency: 500.0,
                                    lowReleaseTime: 25.0,
                                    midReleaseTime: 26.0,
                                    dampingFrequency: 2000.0,
                                    equalizerFrequency1: 400.0,
                                    equalizerLevel1: 1.0,
                                    equalizerFrequency2: 3000.0,
                            equalizerLevel2: 0.3,
                                    dryWetMix: effectsData.reverbDryWetMix)
                
        peakLimiter = PeakLimiter(reverb)
        
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
        effectsData.highPassCutoff = 20.0
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

