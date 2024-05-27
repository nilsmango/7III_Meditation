//
//  MonthlyChart.swift
//  Meditation
//
//  Created by Simon Lang on 27.05.2024.
//

import SwiftUI
import Charts

struct MonthlyChart: View {
    @ObservedObject var meditationManager: MeditationManager
    
    let startOfMonth = getStartOfMonth(numberOfMonthsFromNow: 3)
    
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
                    if let numberOfMinutes = value.as(Int.self) {
                        AxisValueLabel {
                            Text(String(numberOfMinutes) + " Min.")
                        }
                    }
                    AxisGridLine()
                    
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month, count: 1))
            }
            .chartScrollableAxes(.horizontal)
            .chartScrollPosition(x: .constant(startOfMonth))
            .chartXVisibleDomain(length: 365 / 3 * 24 * 60 * 60)
            .frame(height: 250)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.whiteAndBlack)
        }
        .padding(.horizontal)
    }
}

#Preview {
    MonthlyChart(meditationManager: MeditationManager())
}
