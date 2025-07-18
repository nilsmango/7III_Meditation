//
//  ThirtyDaysChart.swift
//  Meditation
//
//  Created by Simon Lang on 28.05.2024.
//

import SwiftUI
import Charts

struct ThirtyDaysChart: View {
    @ObservedObject var meditationManager: TheModel
    
    let xWidth = 6
    
    // Set the time to midnight -(xWidth - 1) for value
    let startOfDay = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -5, to: Date())!)
    
    var body: some View {
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
                    if let numberOfMinutes = value.as(Double.self), numberOfMinutes == floor(numberOfMinutes) {
                        // only show a label if it is a whole double like 1.0
                        AxisValueLabel {
                            Text(String(Int(floor(numberOfMinutes))) + " Min.")
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
            .foregroundStyle(.redAccent)
            .chartXVisibleDomain(length: xWidth * 24 * 60 * 60)
            .frame(height: 250)
        }
    }
}

#Preview {
    let meditationManager = TheModel()
            
    // Sample meditation sessions
    meditationManager.meditationSessions = [
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 2, to: Calendar.current.date(byAdding: .day, value: -12, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 8, to: Calendar.current.date(byAdding: .day, value: -6, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 10, to: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!),
        MeditationSession(startDate: Date(), endDate: Calendar.current.date(byAdding: .minute, value: 12, to: Date())!)
    ]
            
    return ThirtyDaysChart(meditationManager: meditationManager)
}
