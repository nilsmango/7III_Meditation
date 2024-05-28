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
                
                Text(targetDate, style: .timer)
                    .font(.title)
                    .monospacedDigit()
                
            case .alarm:
                Text("Add welcome back text here")
            case .stopped:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .play)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                
                Text(dateToDateFormatted(from: Date(), to: Date().addingTimeInterval(Double(timerInMinutes * 60))))
                
            case .paused:
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    WidgetButtonLabel(buttonState: .resume)
                })
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.circle)
                .tint(.accent)
                    
            case .preparing:
                Text("Add koan here")
            }
            
        }
    }
}

//
//#Preview {
//    TimerBannerView(targetDate: Date().addingTimeInterval(600), timerInMinutes: 10, timerStatus: .stopped)
//}

