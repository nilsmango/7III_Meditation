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
    
    let xWidth = 6
    
    // Set the time to midnight -(xWidth - 1) for value
    let startOfDay = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)

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
            
            VStack {
                Text("Last 30 Days")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                Chart {
                    ForEach(meditationManager.meditationDurationPerDay.sorted(by: { $0.key < $1.key }), id: \.key) { date, duration in
                        BarMark(
                            x: .value("Day", date, unit: .day),
                            y: .value("Duration", duration / 60)
                        )
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        if let numberOfMinutes = value.as(Int.self) {
                            AxisValueLabel {
                                Text(String(numberOfMinutes) + " Min.")
                            }
                        }
                        AxisGridLine()
                        
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 1))
                }
                .chartScrollableAxes(.horizontal)
                .chartScrollPosition(x: .constant(startOfDay))
                .chartXVisibleDomain(length: xWidth * 24 * 60 * 60)
                .frame(height: 250)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.whiteAndBlack)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            MonthlyChart(meditationManager: meditationManager)
            
            
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
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 8, to: Calendar.current.date(byAdding: .day, value: -6, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 10, to: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!),
        MeditationSession(startDate: Date(), endDate: Calendar.current.date(byAdding: .minute, value: 12, to: Date())!)
    ]
            
    return NavigationStack {
        StatisticsView(meditationManager: meditationManager)
    }
    
}
