//
//  NotificationSoundView.swift
//  Meditation
//
//  Created by Simon Lang on 23.05.2024.
//

import SwiftUI
import AVFoundation

struct NotificationSoundView: View {
    @State private var audioPlayer: AVAudioPlayer?
    @Binding var chosenSound: TimerSound
    var title: String
    
    let soundOptions: [TimerSound]
    
    var body: some View {
        
        List {
            Section {
                ForEach(soundOptions) { sound in
                    Button(action: {
                        playSound(fileName: sound.fileName)
                        chosenSound = sound
                    }) {
                        Label(sound.name, systemImage: chosenSound.fileName == sound.fileName ? "circle.fill" : "circle")
                            .tint(.primary)
                    }
                }
            } footer: {
                Label("The sounds Singing Bowl 2, Gong 2, Chimes, Metallophone and their variations were created from samples by https://freesound.org/people/juskiddink/", systemImage: "info.circle")
            }
        }
                    .scrollContentBackground(.hidden)
                    .background(.customGray)
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(.inline)
                }
            
            private func playSound(fileName: String) {
                if let url = Bundle.main.url(forResource: fileName, withExtension: nil) {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.play()
                    } catch {
                        print("Error playing sound: \(error.localizedDescription)")
                    }
                }
            }
        }


#Preview {
    NavigationStack {
        NotificationSoundView(chosenSound: .constant(TimerSound(name: "Kitchen Timer", fileName: "Kitchen Timer Normal.caf")), title: "Start Sound", soundOptions: [
            TimerSound(name: "Kitchen Timer", fileName: "Kitchen Timer Normal.caf"),
            TimerSound(name: "Gong Timer", fileName: "Kitchen  Normal.caf"),
            TimerSound(name: "Bang Thing", fileName: "Timer Normal.caf")
        ])
    }
    
}
