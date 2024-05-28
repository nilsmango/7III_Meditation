//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    @State private var rotation = Angle(degrees: 0.0)
    
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
                            }
                            .animation(.easeInOut(duration: 1.0), value: rotation)
                        
                        Spacer()
                        NavigationLink(destination: StatisticsView(meditationManager: meditationManager)) {
                            StatisticsButton(padding: 5.5)
                                .padding(.vertical, 4)
                        }
                        
                        NavigationLink(destination: OptionsView(meditationManager: meditationManager)) {
                            Label("Options", systemImage: "ellipsis.circle.fill")
                                .font(.title.weight(.ultraLight))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blackWhite, .accent)
                                .labelStyle(.iconOnly)
                                .padding(.trailing)
                                .padding(.vertical, 4)
                        }
                    }
                    
                    Spacer()
                    
                }
                TimerView(meditationManager: meditationManager)
            }
            .background(meditationManager.gradientBackground ? LinearGradient(gradient: Gradient(colors: [.customGray2, .accent]), startPoint: .top, endPoint: .bottom) : LinearGradient(gradient: Gradient(colors: [.customGray2]), startPoint: .top, endPoint: .bottom))
        }        
    }
}

#Preview {
    ContentView(meditationManager: MeditationManager())
}
