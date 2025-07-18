//
//  MeditationView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct MeditationView: View {
    @ObservedObject var meditationManager: TheModel
    @ObservedObject var audioManager: AudioManager
    
    @State private var rotation = Angle(degrees: 0.0)
    
    @State private var emojis: [UUID] = []
    @State private var emoji = "🔥"
    
    var body: some View {
            ZStack {
                VStack {
                   
                    Spacer()
                    
                }
                NoteView(note: meditationManager.backgroundNote)
                
                TimerView(meditationManager: meditationManager)
                
                AttackOfTheEmojiView(emojis: emojis, emoji: emoji)
            }
            .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .redAccent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
            .onAppear {
                meditationManager.checkStatusOfTimer()
            }
            .navigationTitle("Meditation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                        Text("")
                    }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    StreakButton(streakNumber: meditationManager.meditationTimer.statistics.currentStreak)
                        .padding(.horizontal)
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
                        Image(systemName: "waveform.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.blackWhite, .redAccent)

                    }
                    
                    NavigationLink(destination: StatisticsView(meditationManager: meditationManager)) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.caption2)
                            .foregroundStyle(.blackWhite)
                            .padding(5.2)
                            .background {
                                Circle()
                                    .foregroundStyle(.redAccent)
                            }
                    }
                    
                    NavigationLink(destination: OptionsView(meditationManager: meditationManager)) {
                        Image(systemName: "ellipsis.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.blackWhite, .redAccent)
                    }
                }
            }
        }
    }

#Preview {
    NavigationStack {
        MeditationView(meditationManager: TheModel(), audioManager: AudioManager())
    }
}
