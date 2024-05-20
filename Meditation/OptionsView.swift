//
//  OptionsView.swift
//  Meditation
//
//  Created by Simon Lang on 20.05.2024.
//

import SwiftUI

struct OptionsView: View {
    @ObservedObject var meditationManager: MeditationManager

    var body: some View {
        List {
            Section("Messages") {
                TextField("Welcome Back Text", text: $meditationManager.welcomeMessage)
                
                TextField("Meditation Started Text", text: $meditationManager.startMessage)
            }
            
            Section("Sounds") {
                Picker("Start Sound", selection: $meditationManager.meditationTimer.startSound) {
                    ForEach(TimerSound.allCases, id: \.self) { sound in
                                        Text(sound.prettyString).tag(sound)
                                    }
                            }
                
                Picker("End Sound", selection: $meditationManager.meditationTimer.endSound) {
                    ForEach(TimerSound.allCases, id: \.self) { sound in
                                        Text(sound.prettyString).tag(sound)
                                    }
                            }
                
//                Picker("Interval Sound", selection: $meditationManager.meditationTimer.intervalSound) {
//                    ForEach(TimerSound.allCases, id: \.self) { sound in
//                                        Text(sound.prettyString).tag(sound)
//                                    }
//                            }
                // TODO: koans, reminders to meditate, intervals
            }
        }
    }
}

#Preview {
    OptionsView(meditationManager: MeditationManager())
}
