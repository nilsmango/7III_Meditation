//
//  MonthlyChart.swift
//  Meditation
//
//  Created by Simon Lang on 27.05.2024.
//

import SwiftUI
import Charts

struct MonthlyChart: View {
    @ObservedObject var meditationManager: TheModel
    
    let startOfMonth = getStartOfMonth(numberOfMonthsFromNow: 5)
    
    var body: some View {
        VStack {
            Text("Monthly Averages")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            Chart {
                ForEach(meditationManager.averageMeditationsPerMonth.sorted(by: { $0.key < $1.key }), id: \.key) { dateComponent, duration in
                    // converting DateComponents to Date
                    if let date = Calendar.current.date(from: dateComponent) {
                        BarMark(
                            x: .value("Month", date, unit: .month),
                            y: .value("Duration", duration / 60)
                        )
                    }
                    
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    // only show a label if it is a whole double
                    if let numberOfMinutes = value.as(Double.self), numberOfMinutes == floor(numberOfMinutes) {
                        AxisValueLabel {
                            Text(String(Int(floor(numberOfMinutes))) + " Min.")
                        }
                    }
                    AxisGridLine()
                    
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 1)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(date, format: .dateTime.month(.abbreviated).year(.twoDigits))
                        }
                    }
                    AxisGridLine()
                    AxisTick()
                }
            }
            .chartScrollableAxes(.horizontal)
            .chartScrollPosition(x: .constant(startOfMonth))
            .foregroundStyle(.redAccent)
            .chartXVisibleDomain(length: 366 / 2 * 24 * 60 * 60)
            .frame(height: 250)
        }
        
    }
}

#Preview {
    let meditationManager = TheModel()
            
    // Sample meditation sessions
    meditationManager.meditationSessions = [
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -212, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 12, to: Calendar.current.date(byAdding: .day, value: -212, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -206, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 18, to: Calendar.current.date(byAdding: .day, value: -206, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -203, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 23, to: Calendar.current.date(byAdding: .day, value: -203, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -202, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -202, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -201, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -201, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -112, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 12, to: Calendar.current.date(byAdding: .day, value: -112, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -106, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 18, to: Calendar.current.date(byAdding: .day, value: -106, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -103, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 10, to: Calendar.current.date(byAdding: .day, value: -103, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -102, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -102, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -101, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -101, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 2, to: Calendar.current.date(byAdding: .day, value: -12, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 8, to: Calendar.current.date(byAdding: .day, value: -6, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 10, to: Calendar.current.date(byAdding: .day, value: -3, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 4, to: Calendar.current.date(byAdding: .day, value: -2, to: Date())!)!),
        MeditationSession(startDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, endDate: Calendar.current.date(byAdding: .minute, value: 5, to: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!),
        MeditationSession(startDate: Date(), endDate: Calendar.current.date(byAdding: .minute, value: 12, to: Date())!)
    ]
            
    return MonthlyChart(meditationManager: meditationManager)
}
