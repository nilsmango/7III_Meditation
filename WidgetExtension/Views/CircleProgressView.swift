//
//  CircleProgressView.swift
//  Meditation
//
//  Created by Simon Lang on 30.05.2024.
//

import SwiftUI

struct CircleProgressView: View {
    let timerStatus: TimerStatus
    let targetDate: Date
    let timerInMinutes: Int
    var expanded: Bool = false
    
    var body: some View {
        if expanded {
            if timerStatus == .running {
                ProgressView(timerInterval: targetDate.addingTimeInterval(-Double(timerInMinutes*60))...targetDate, countsDown: false) {
                             Text("")
                         } currentValueLabel: {
                             Text("")
                          }
                .tint(.redAccent)
                .progressViewStyle(.circular)
                
            } else {
                ProgressView(value: 0.0) {
                             Text("")
                         } currentValueLabel: {
                             Text("")
                          }
                .tint(.redAccent)
                .progressViewStyle(.circular)
            }
            
        } else {
            if timerStatus == .running {
                ProgressView(timerInterval: targetDate.addingTimeInterval(-Double(timerInMinutes*60))...targetDate, countsDown: false) {
                             Text("")
                         } currentValueLabel: {
                             Text("")
                          }
                .tint(.redAccent)
                .progressViewStyle(.circular)
                .frame(width: 25, height: 25)
            } else {
                ProgressView(value: 0.0) {
                             Text("")
                         } currentValueLabel: {
                             Text("")
                          }
                .tint(.redAccent)
                .progressViewStyle(.circular)
                .frame(width: 25, height: 25)
            }
        }
        
    }
}

#Preview {
    CircleProgressView(timerStatus: .running, targetDate: Date().addingTimeInterval(-600), timerInMinutes: 10)
}
