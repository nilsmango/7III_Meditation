//
//  TimerBannerView.swift
//  Meditation
//
//  Created by Simon Lang on 28.05.2024.
//

import SwiftUI

struct TimerBannerView: View {
    var targetDate: Date
    var timerInMinutes: Int
    var timerStatus: TimerStatus
    var welcomeText: String
    var koanText: String
    
    var body: some View {
        
        HStack {
            switch timerStatus {
            case .running:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .pause)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .stop)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                .padding(.trailing, 4)

                ProgressView(timerInterval: targetDate.addingTimeInterval(-Double(timerInMinutes*60))...targetDate, countsDown: false) {
                             Text("Meditation")
                         } currentValueLabel: {
                             Text(targetDate, style: .timer)
                          }
                .tint(.accent)
                
            case .alarm:
                Spacer()
                Text(welcomeText)
                Spacer()
            case .stopped:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .play)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                .padding(.trailing, 43)
                
//                Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                
                ProgressView(value: 0.0) {
                             Text("Meditation")
                         } currentValueLabel: {
                             Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                          }
                .tint(.accent)
                
            case .paused:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .resume)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .stop)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                .padding(.trailing, 4)
                
                ProgressView(value: 0.0) {
                             Text("Meditation")
                         } currentValueLabel: {
                             Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                          }
                .tint(.accent)
                    
            case .preparing:
                Spacer()
                Text(koanText)
                Spacer()
            }
            
        }
    }
}

//
//#Preview {
//    TimerBannerView(targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, timerStatus: .stopped)
//}

