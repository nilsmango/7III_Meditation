//
//  AudioManager.swift
//  Meditation
//
//  Created by Simon Lang on 02.06.2024.
//

import Foundation
import AudioKit
import SoundpipeAudioKit
import AVFAudio
import SwiftUI

struct AudioFile {
    var fileName: String
    var fileExtension: String
}

enum PlayStatus {
    case playing, stopped, fadingOut
}

struct TapeMachineControl: Identifiable {
    var fileName: String
    var volume: AUValue = 0.0
    var pitchShift: AUValue = 0.0
    var variSpeed: AUValue = 1.0
    let id = UUID()
}

struct NoiseData {
    @AppStorageAUValue("brownianAmplitude", defaultValue: 0.0) var brownianAmplitude
    @AppStorageAUValue("pinkAmplitude", defaultValue: 0.0) var pinkAmplitude
    @AppStorageAUValue("whiteAmplitude", defaultValue: 0.0) var whiteAmplitude
    
    @AppStorageAUValue("userVolume", defaultValue: 0.0) var userVolume
    @AppStorageAUValue("userPitchShift", defaultValue: 0.0) var userPitchShift
    @AppStorageAUValue("userVariSpeed", defaultValue: 1.0) var userVariSpeed
}

struct EffectsData {
    @AppStorageAUValue("distortionMix", defaultValue: 0.0) var distortionMix
    
    @AppStorageAUValue("moogCutoff", defaultValue: 22050.0) var moogCutoff
    @AppStorageAUValue("moogResonance", defaultValue: 0.0) var moogResonance
    var logMoogCutoff: AUValue {
        get {
            return log10(moogCutoff)
        }
        set {
            moogCutoff = pow(10, newValue)
        }
    }
    
    @AppStorageAUValue("highPassCutoff", defaultValue: 10.0) var highPassCutoff
    @AppStorageAUValue("highPassResonance", defaultValue: 0.0) var highPassResonance
    var logHighPassCutoff: AUValue {
        get {
            return log10(highPassCutoff)
        }
        set {
            highPassCutoff = pow(10, newValue)
        }
    }
    @AppStorageAUValue("endVariRate", defaultValue: 1.0) var endVariRate
    @AppStorageAUValue("delayFeedback", defaultValue: 0.0) var delayFeedback
    @AppStorageAUValue("delayTime", defaultValue: 0.724) var delayTime
    @AppStorageAUValue("delayDryWetMix", defaultValue: 0.0) var delayDryWetMix
    
    @AppStorageAUValue("reverbDryWetMix", defaultValue: 0.0) var reverbDryWetMix
    
}

class AudioManager: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
    private var brown = BrownianNoise()
    private var pink = PinkNoise()
    private var white = WhiteNoise()
    
    private let audioFiles: [AudioFile] = (0...7).map { AudioFile(fileName: "buddha0\($0)", fileExtension: "aif") } + [AudioFile(fileName: "Basic Bells 1", fileExtension: "caf")]
    
    private var audioPlayers = [AudioPlayer]()
    private var timePitchers = [TimePitch]()
    private var variSpeeds = [VariSpeed]()
    
    @Published var tapeMachineControls = [TapeMachineControl]() {
        didSet {
            for (index, player) in audioPlayers.enumerated() {
                player.volume = tapeMachineControls[index].volume
                timePitchers[index].pitch = tapeMachineControls[index].pitchShift
                variSpeeds[index].rate = tapeMachineControls[index].variSpeed
            }
        }
    }

    private var userTimePitcher: TimePitch!
    private var userVariSpeed: VariSpeed!
    
    private var endVariSpeed: VariSpeed!
    private var distortion: Distortion!
    private var moogLadder: LowPassFilter!
    private var highPass: HighPassFilter!
    private var delay: VariableDelay!
    private var delayWet = Mixer()
    private var delayDry = Mixer()
    private var delayMix = Mixer()
    
    private var reverb: ZitaReverb!
    
    private var peakLimiter: PeakLimiter!
    private var preMixer = Mixer()
    
    private var lowpassMixer = Mixer()
    private var highPassMixer = Mixer()
    private var filterMix = Mixer()
    
    private var mixer = Mixer()
    
    @Published var soundData = NoiseData() {
        didSet {
            brown.amplitude = soundData.brownianAmplitude
            pink.amplitude = soundData.pinkAmplitude
            white.amplitude = soundData.whiteAmplitude
            
            userSelectedPlayer?.volume = soundData.userVolume
            userTimePitcher?.pitch = soundData.userPitchShift
            userVariSpeed?.rate = soundData.userVariSpeed
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
    
    @Published var isPlaying: PlayStatus = .stopped
    
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
        delayWet.volume = 0.0
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
            isPlaying = .playing
            for player in audioPlayers {
                player.play()
            }
            if let player = userSelectedPlayer {
                player.play()
            }
            fadeIn()
        } catch {
            print("AudioEngine failed to start: \(error)")
        }
    }
    
    func stop() {
        isPlaying = .fadingOut
        fadeOut {
            for player in self.audioPlayers {
                player.stop()
            }
            if let player = self.userSelectedPlayer {
                player.stop()
            }
            self.engine.stop()
            self.isPlaying = .stopped
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
        let duration: Double = 1.0  // Duration of the fade in seconds
        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * (duration / Double(steps))) {
                let progress = Double(i) / Double(steps)
                self.mixer.volume = AUValue(pow(progress, 2.0))  // Exponential fade in
            }
        }
    }
    
    private func fadeOut(completion: @escaping () -> Void) {
        let steps = 100
        let duration: Double = 2.5  // Duration of the fade in seconds
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
    
    // MARK: - User Tape Machine
    var userSelectedPlayer: AudioPlayer?
    private var audioRecorder: AVAudioRecorder?
    @Published var isRecording = false
    
    // Add methods for user file selection and recording
    func loadUserSelectedAudio(url: URL) {
        if let userPlayer = userSelectedPlayer {
            userPlayer.stop()
            do {
                try userPlayer.load(url: url, buffered: true)
                if engine.avEngine.isRunning {
                    userPlayer.play()
                }
            } catch {
                print("Error loading new url: \(error.localizedDescription)")
            }
            
        } else {
            let userSelectedPlayer = AudioPlayer(url: url, buffered: true)!
            userSelectedPlayer.isLooping = true
            self.userSelectedPlayer = userSelectedPlayer
            self.userSelectedPlayer!.volume = soundData.userVolume
            
            // time pitchers
            userTimePitcher = TimePitch(self.userSelectedPlayer!, pitch: soundData.userPitchShift)
            
            // vari speeds
            userVariSpeed = VariSpeed(userTimePitcher, rate: soundData.userVariSpeed)
            
            preMixer.addInput(userVariSpeed)
            
            if engine.avEngine.isRunning {
                self.userSelectedPlayer!.play()
            }
        }
    }
    
    func startRecording() {
        let fileName = "userRecording.m4a"
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = paths[0].appendingPathComponent(fileName)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record(forDuration: 20.0)
            isRecording = true
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        if let fileURL = audioRecorder?.url {
            loadUserSelectedAudio(url: fileURL)
        }
    }
    
    
    // MARK: - Loop Fading
    func fadeToNextLoop(oldIndex: Int, newIndex: Int) {
        let targetVolume = tapeMachineControls[oldIndex].volume
        let steps = 100
        let duration: Double = 2.0 // Duration of the fade in seconds

        for i in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * (duration / Double(steps))) {
                let progress = Double(i) / Double(steps)
                
                // Fade out the old volume
                self.tapeMachineControls[oldIndex].volume = targetVolume * Float((1.0 - progress))
                
                // Fade in the new volume
                self.tapeMachineControls[newIndex].volume = targetVolume * Float(progress)
            }
        }
    }
}

