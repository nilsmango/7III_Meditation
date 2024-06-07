//
//  AudioManager.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit

struct AudioFile {
    var fileName: String
    var fileExtension: String
}

struct TapeMachineControl: Identifiable {
    var fileName: String
    var volume: AUValue = 0.0
    var pitchShift: AUValue = 0.0
    var variSpeed: AUValue = 1.0
    let id = UUID()
}

struct NoiseData {
    var brownianAmplitude: AUValue = 0.0
    var pinkAmplitude: AUValue = 0.0
    var whiteAmplitude: AUValue = 0.0
}

struct EffectsData {
    var distortionMix: AUValue = 0.0
    
    var moogCutoff: AUValue = 22050.0
    var moogResonance: AUValue = 0.0
    var logMoogCutoff: AUValue {
            get {
                return log10(moogCutoff)
            }
            set {
                moogCutoff = pow(10, newValue)
            }
        }
    
    var highPassCutoff: AUValue = 10.0
    var highPassResonance: AUValue = 0.0
    var logHighPassCutoff: AUValue {
            get {
                return log10(highPassCutoff)
            }
            set {
                highPassCutoff = pow(10, newValue)
            }
        }
    
    var endVariRate: AUValue = 1.0
    
    var delayFeedback: AUValue = 0.0
    var delayTime: AUValue = 0.73
    var delayDryWetMix: AUValue = 0.0

    var reverbDryWetMix: AUValue = 0.0
    
}

class AudioManager: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    var brown = BrownianNoise()
    var pink = PinkNoise()
    var white = WhiteNoise()
    
    private let audioFiles = [AudioFile(fileName: "Phonogeneli", fileExtension: "aif"), AudioFile(fileName: "060", fileExtension: "aif"), AudioFile(fileName: "Basic Bells 1", fileExtension: "caf"), AudioFile(fileName: "047", fileExtension: "aif")]
    
    private var audioPlayers = [AudioPlayer]()
    private var timePitchers = [TimePitch]()
    private var variSpeeds = [VariSpeed]()
    
    @Published var tapeMachineControls = [TapeMachineControl]() {
        didSet {
            for (index, player) in audioPlayers.enumerated() {
                player.volume = tapeMachineControls[index].volume
                timePitchers[index].pitch = tapeMachineControls[index].pitchShift
                timePitchers[index].rate = tapeMachineControls[index].variSpeed
            }
            
        }
    }

    
    var distortion: Distortion!
    var moogLadder: LowPassFilter!
    var highPass: HighPassFilter!
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
    
    var endVariSpeed: VariSpeed!

    @Published var soundData = NoiseData() {
        didSet {
            brown.amplitude = soundData.brownianAmplitude
            pink.amplitude = soundData.pinkAmplitude
            white.amplitude = soundData.whiteAmplitude
        }
    }
    
    
    @Published var effectsData = EffectsData() {
        didSet {
            distortion.finalMix = effectsData.distortionMix
            moogLadder.cutoffFrequency = effectsData.moogCutoff
            moogLadder.resonance = effectsData.moogResonance
            highPass.cutoffFrequency = effectsData.highPassCutoff
            highPass.resonance = effectsData.highPassResonance
            
            endVariSpeed.rate = effectsData.endVariRate
            delay.feedback = effectsData.delayFeedback
            delay.time = effectsData.delayTime
            delayWet.volume = effectsData.delayDryWetMix
            delayDry.volume = abs(effectsData.delayDryWetMix - 1.0)
            reverb.dryWetMix = effectsData.reverbDryWetMix
        }
    }
    
    @Published var isPlaying = false

    init() {
        for (index, audioFile) in audioFiles.enumerated() {
            // create controls
            tapeMachineControls.append(TapeMachineControl(fileName: audioFiles[index].fileName))
            
            // audio players
            guard let fileURL = Bundle.main.url(forResource: audioFile.fileName, withExtension: audioFile.fileExtension) else {
                fatalError("Wav file not found in bundle")
            }
            
            let audioPlayer = AudioPlayer(url: fileURL, buffered: true)!
            audioPlayer.volume = 0.0
            audioPlayer.isLooping = true
            audioPlayers.append(audioPlayer)
            
            // time pitchers
            let timePitcher = TimePitch(audioPlayers[index], pitch: tapeMachineControls[index].pitchShift)
            timePitchers.append(timePitcher)
            
            // vari speeds
            let variSpeed = VariSpeed(timePitchers[index], rate: tapeMachineControls[index].variSpeed)
            variSpeeds.append(variSpeed)
            
            preMixer.addInput(variSpeeds[index])
        }
        
        brown.start()
        pink.start()
        white.start()
        
        brown.amplitude = soundData.brownianAmplitude
        pink.amplitude = soundData.pinkAmplitude
        white.amplitude = soundData.whiteAmplitude

        preMixer.addInput(brown)
        preMixer.addInput(pink)
        preMixer.addInput(white)
        
        endVariSpeed = VariSpeed(preMixer, rate: effectsData.endVariRate)
        
        distortion = Distortion(endVariSpeed, ringModFreq2: 173, ringModMix: 0, decimationMix: 0.0, finalMix: effectsData.distortionMix)
        
        moogLadder = LowPassFilter(distortion, cutoffFrequency: effectsData.moogCutoff, resonance: effectsData.moogResonance)
        lowpassMixer.addInput(moogLadder)
        
        highPass = HighPassFilter(moogLadder, cutoffFrequency: effectsData.highPassCutoff, resonance: effectsData.highPassResonance)
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
            for player in audioPlayers {
                player.play()
            }
            fadeIn()
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }
    
    func stop() {
        self.isPlaying = false
        
        fadeOut {
            for player in self.audioPlayers {
                player.stop()
            }
            self.engine.stop()
        }
    }
    
    func startHighPass() {
//        effectsData.highPassCutoff = 10.0
//        effectsData.highPassResonance = 0.0
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
        let duration: Double = 4.0  // Duration of the fade in seconds
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

