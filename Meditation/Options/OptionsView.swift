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
                    
                    Toggle("Show Koan", isOn: $meditationManager.meditationTimer.showKoan)
                    
                    if meditationManager.meditationTimer.showKoan {
                        NavigationLink("Edit Koans", destination: KoansEditView(meditationManager: meditationManager))
                    }
                }
                
                Section("Meditation Sounds") {
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.startSound, title: "Start Sound", soundOptions: meditationManager.soundOptions)
                    } label: {
                        HStack {
                            Text("Start Sound")
                            Spacer()
                            
                            Text(meditationManager.meditationTimer.startSound.name)
                                .opacity(0.5)
                        }
                    }
                    
                    NavigationLink {
                        NotificationSoundView(chosenSound: $meditationManager.meditationTimer.endSound, title: "End Sound", soundOptions: meditationManager.soundOptions)
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
                    // TODO: reminders to meditate, intervals
                }

                
                Section("Misc") {
                    Picker("Preparation Time", selection: $meditationManager.meditationTimer.preparationTime) {
                        ForEach(1...60, id: \.self) { seconds in
                            Text("\(seconds) \(seconds == 1 ? "Second" : "Seconds")")
                        }
                    }
    //                .pickerStyle(.wheel)
                    
                    Toggle("Gradient Background", isOn: $meditationManager.gradientBackground)
                }
                
                Section(content:  {
                    Toggle("Activate Reminders", isOn: $meditationManager.reminders.activateReminders)
                    
                    if meditationManager.reminders.activateReminders {
                        NavigationLink {
                            NotificationSoundView(chosenSound: $meditationManager.meditationTimer.reminderSound, title: "Reminder Sound", soundOptions: meditationManager.soundOptions)
                        } label: {
                            HStack {
                                Text("Reminder Sound")
                                Spacer()
                                Text(meditationManager.meditationTimer.reminderSound.name)
                                    .opacity(0.5)
                            }
                        }
                        
                        DatePicker("Reminder Time", selection: $meditationManager.reminders.reminderTime, displayedComponents: .hourAndMinute)
                                        
//                        Toggle("Remind Again", isOn: $meditationManager.reminders.remindAgain)
                                                
                    }
                }, header: {
                    Text("Reminders")
                }, footer: {
//                    Label("**Remind Again** will remind you to meditate if you don't meditate after the first reminder.", systemImage: "info.circle")
                })
                .onChange(of: meditationManager.reminders) {
                    meditationManager.updateReminders()
                }
            }
            .scrollContentBackground(.hidden)
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
