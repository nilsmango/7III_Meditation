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
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.startSound, title: "Start Sound")
                    } label: {
                        HStack {
                            Text("Start Sound")
                            Spacer()
                            
                            Text(meditationManager.meditationTimer.startSound.name)
                                .opacity(0.5)
                        }
                    }
                    
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.endSound, title: "End Sound")
                    } label: {
                        HStack {
                            Text("End Sound")
                            Spacer()
                            Text(meditationManager.meditationTimer.endSound.name)
                                .opacity(0.5)
                        }
                    }
                    
                    
    //                Picker("Interval Sound", selection: $meditationManager.meditationTimer.intervalSound) {
    //                    ForEach(TimerSound.allCases, id: \.self) { sound in
    //                                        Text(sound.prettyString).tag(sound)
    //                                    }
    //                            }
                    // TODO: koans, reminders to meditate, intervals
                }
                
                Section("Misc") {
                    Picker("Preparation Time", selection: $meditationManager.meditationTimer.preparationTime) {
                        ForEach(1...60, id: \.self) { seconds in
                            Text("\(seconds) \(seconds == 1 ? "Second" : "Seconds")")
                        }
                    }
    //                .pickerStyle(.wheel)
                }
            }
            .scrollContentBackground(.hidden) // Hides the default background
            .background(.customGray)
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    NavigationView {
        OptionsView(meditationManager: MeditationManager())
    }
}
