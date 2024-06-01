//
//  AudioManager.swift
//  Meditation
//
//  Created by Simon Lang on 01.06.2024.
//

import AVFoundation

class AudioManager: ObservableObject {
    private var audioEngine: AVAudioEngine
    private var noiseNode: AVAudioPlayerNode
    private var lowPassFilter: AVAudioUnitEQ
    private var highPassFilter: AVAudioUnitEQ
    private var isPlaying: Bool = false

    init() {
        audioEngine = AVAudioEngine()
        noiseNode = AVAudioPlayerNode()
        lowPassFilter = AVAudioUnitEQ(numberOfBands: 1)
        highPassFilter = AVAudioUnitEQ(numberOfBands: 1)
        
        setupFilters()
        setupAudioEngine()
    }
    
    private func setupFilters() {
        lowPassFilter.bands[0].filterType = .lowPass
        lowPassFilter.bands[0].bypass = true
        lowPassFilter.bands[0].frequency = 1000
        
        highPassFilter.bands[0].filterType = .highPass
        highPassFilter.bands[0].bypass = true
        highPassFilter.bands[0].frequency = 500
    }
    
    private func setupAudioEngine() {
        audioEngine.attach(noiseNode)
        audioEngine.attach(lowPassFilter)
        audioEngine.attach(highPassFilter)
        
        let format = audioEngine.outputNode.outputFormat(forBus: 0)
        audioEngine.connect(noiseNode, to: lowPassFilter, format: format)
        audioEngine.connect(lowPassFilter, to: highPassFilter, format: format)
        audioEngine.connect(highPassFilter, to: audioEngine.outputNode, format: format)
        
        try? audioEngine.start()
    }
    
    func startNoise() {
        guard !isPlaying else { return }
        
        guard !isPlaying else { return }
                
                let buffer = AVAudioPCMBuffer(pcmFormat: noiseNode.outputFormat(forBus: 0), frameCapacity: 1024)!
                buffer.frameLength = 1024
                
                let leftChannel = buffer.floatChannelData![0]
                let rightChannel = buffer.floatChannelData![1]
                
                for frame in 0..<buffer.frameLength {
                    let noise = generateGaussianNoise(mean: 0.0, stdDev: 0.1)
                    leftChannel[Int(frame)] = noise
                    rightChannel[Int(frame)] = noise
                }
        
        noiseNode.scheduleBuffer(buffer, at: nil, options: .loops, completionHandler: nil)
        noiseNode.play()
        isPlaying = true
    }
    
    func stopNoise() {
        guard isPlaying else { return }
        
        noiseNode.stop()
        isPlaying = false
    }
    
    func setLowPassFrequency(_ frequency: Float) {
        lowPassFilter.bands[0].frequency = frequency
        lowPassFilter.bands[0].bypass = false
    }
    
    func setHighPassFrequency(_ frequency: Float) {
        highPassFilter.bands[0].frequency = frequency
        highPassFilter.bands[0].bypass = false
    }
    
    func toggleLowPassFilter(_ isActive: Bool) {
        lowPassFilter.bands[0].bypass = !isActive
    }
    
    func toggleHighPassFilter(_ isActive: Bool) {
        highPassFilter.bands[0].bypass = !isActive
    }
    
    private func generateGaussianNoise(mean: Float, stdDev: Float) -> Float {
            let u1 = Float.random(in: 0...1)
            let u2 = Float.random(in: 0...1)
            let z0 = sqrt(-2.0 * log(u1)) * cos(2.0 * .pi * u2)
            return z0 * stdDev + mean
        }
}
