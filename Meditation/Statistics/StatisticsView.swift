//
//  StatisticsView.swift
//  Meditation
//
//  Created by Simon Lang on 26.05.2024.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var meditationManager: MeditationManager

    let screenWidth = UIScreen.main.bounds.size.width
    let padding = 16.0
    var frameWidth: Double {
        return (screenWidth/2) - padding * 1.5
    }
    
    var body: some View {
        ScrollView {
            HStack {
                StreakTile(streakText: "Active Streak", streakNumber: String(meditationManager.meditationTimer.statistics.currentStreak), frameWidth: frameWidth)
                
                Spacer(minLength: 0.0)
                
                StreakTile(streakText: "Longest Streak", streakNumber: String(meditationManager.meditationTimer.statistics.longestStreak), frameWidth: frameWidth)
            }
            .padding(.horizontal)
            .padding(.top)
            
            ThirtyDaysChart(meditationManager: meditationManager)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.whiteAndListGray)
            }
            .padding(.horizontal)
            .padding(.vertical, padding / 2)
            
            MonthlyChart(meditationManager: meditationManager)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.whiteAndListGray)
                }
                .padding(.horizontal)
            
        }
        .background(.customGray)
        .navigationTitle("Statistics")
        
        
    }
}

#Preview {
    let meditationManager = MeditationManager()
            
    // Sample meditation sessions
    meditationManager.meditationSessions = [
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 2, to: Calendar.current.date(byAdding: .day, value: -12, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -28, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 8, to: Calendar.current.date(byAdding: .day, value: -28, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 10, to: Calendar.current.date(byAdding: .day, value: -4, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 9, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!)
    ]
            
    return NavigationStack {
        StatisticsView(meditationManager: meditationManager)
    }
    
}
