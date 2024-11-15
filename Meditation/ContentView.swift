//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    @ObservedObject var audioManager: AudioManager
    
    @State private var rotation = Angle(degrees: 0.0)
    
    @State private var emojis: [UUID] = []
    @State private var emoji = "🔥"
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        StreakButton(streakNumber: meditationManager.meditationTimer.statistics.currentStreak)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .rotationEffect(rotation)
                            .onTapGesture {
                                rotation += Angle(degrees: 360)
                                if meditationManager.meditationTimer.statistics.currentStreak < 1 {
                                    emoji = "😐"
                                } else {
                                    emoji = "🔥"
                                }
                                for _ in 0..<18*6 {
                                    emojis.append(UUID())
                                }
                            }
                            .animation(.easeInOut(duration: 1.0), value: rotation)
                        
                        Spacer()
                        
                        NavigationLink(destination: BuddhaBoxLayout(meditationManager: meditationManager, audioManager: audioManager)) {
                            Label("Options", systemImage: "waveform.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blackWhite, .accent)
                                .labelStyle(.iconOnly)
                                .padding(.trailing, 8)
                        }
                        
                        NavigationLink(destination: StatisticsView(meditationManager: meditationManager)) {
                            StatisticsButton(padding: 6.2)
                                .padding(.trailing, 8)
                        }
                        
                        NavigationLink(destination: OptionsView(meditationManager: meditationManager)) {
                            Label("Options", systemImage: "ellipsis.circle.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blackWhite, .accent)
                                .labelStyle(.iconOnly)
                                .padding(.trailing)
                                .padding(.trailing, 4)
                        }
                    }
                    
                    Spacer()
                    
                }
                TimerView(meditationManager: meditationManager)
                
                AttackOfTheEmojiView(emojis: emojis, emoji: emoji)
            }
            .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
            .onAppear {
                meditationManager.checkStatusOfTimer()
            }
        }
    }
}

#Preview {
    ContentView(meditationManager: MeditationManager(), audioManager: AudioManager())
}
