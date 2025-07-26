//
//  AlternativeActionView.swift
//  Meditation
//
//  Created by Simon Lang on 25.07.2025.
//

import SwiftUI

struct AlternativeActionView: View {
    @ObservedObject var model: TheModel
    @State private var showTopUpTimeView: Bool = false
    
    let group1Activities: [AlternativeActivity]
    let group2Activities: [AlternativeActivity]

    var body: some View {
        if showTopUpTimeView {
            TopUpTimeView(model: model)
        } else if let message = model.flashMessage {
            VStack(spacing: 16) {
                Text(model.messageEmoji)
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(.greenAccent)
                    .transition(.scale)
                Text(message)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()


        } else {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if model.hasSelectedAlternatives {
                        // Split up the randomized selection in two groups

                        // Group 1
                        ForEach(group1Activities) { activity in
                            Button {
                                model.run(activity: activity)
                            } label: {
                                ButtonLabel(iconName: activity.symbol ?? "○", labelText: activity.name, accentColor: .accent, iconIsEmoji: true)
                            }
                        }

                        Button {
                            showTopUpTimeView = true
                            
                        } label: {
                            if model.easyTopUpButton {
                                ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .accent)
                            } else {
                                ButtonLabel(iconName: randomEmoji(), labelText: randomText(), accentColor: .accent, iconIsEmoji: true)
                            }
                            
                        }

                        // Group 2
                        ForEach(group2Activities) { activity in
                            Button {
                                model.run(activity: activity)
                            } label: {
                                ButtonLabel(iconName: activity.symbol ?? "○", labelText: activity.name, accentColor: .accent, iconIsEmoji: true)
                            }
                        }
                        .navigationTitle("Would you not rather?")
                        .navigationBarTitleDisplayMode(.inline)
                        
                    } else {
                        Text("You have not yet selected any Alternative Actions. Go back and select some Alternative Actions to show them here!")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.yellow.opacity(0.2))
                            .cornerRadius(10)
                            .font(.headline)
                        
                        
                        Button {
                            showTopUpTimeView = true
                            
                        } label: {
                            ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .accent)
                        }
                    }
                    
                }
            }
            .padding()
        }
        
    }
    
    // Emojis for time/need/addiction/pain relief theme
    let emojis = [
        "⏰", "⏳", "⌛", "⏱️", "⏲️", "📱", "🙈", "🤚",
        "😩", "😫", "😰", "😅", "🥺", "😔", "😞", "😓",
        "🙏", "🍹", "🥴", "😵‍💫", "🫨", "😮‍💨", "😤", "😖",
        "💊", "🩹", "❤️‍🩹", "🫀", "💔", "⚡", "💉", "😳",
        "🆘", "🚨", "💭", "💨", "☑️", "😬", "🙊", "🤿", "☠️", "😶‍🌫️", "🤡", "💩", "👻", "🤌", "⚡️", "⛈️"
    ]

    // Text labels with variety and shorter lengths
    let textLabels = [
        "Give me more Time",
        "No, need App",
        "Top up Time",
        "Just 5 minutes",
        "Quick Check",
        "One Peek",
        "Brief Look",
        "Emergency Access",
        "Urgent Need",
        "Must check now",
        "Can't wait",
        "Need Relief",
        "Feeling anxious",
        "Quick Fix",
        "Temporary Access",
        "Short Break",
        "Moment please",
        "Really need this",
        "Won't take long",
        "Last Time today",
        "Special Occasion",
        "Making Exception",
        "Bend the Rules",
        "Override Limit",
        "Add more Time",
        "Unlock briefly",
        "Unlock some Time",
    ]

    // Random selection functions
    func randomEmoji() -> String {
        return emojis.randomElement() ?? "⏰"
    }

    func randomText() -> String {
        return textLabels.randomElement() ?? "Need more Time"
    }
}

#Preview {
    NavigationStack {
        AlternativeActionView(model: TheModel(), group1Activities: [], group2Activities: [])
    }
}
