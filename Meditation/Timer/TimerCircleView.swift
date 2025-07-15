//
//  TimerCircleView.swift
//  Meditation
//
//  Created by Simon Lang on 23.05.2024.
//

import SwiftUI

struct TimerCircleView: View {
    var progress: Double
    var accentColor: Color
    var updateInterval: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(accentColor)
                .opacity(0.2)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(accentColor)
                .rotationEffect(Angle(degrees: 270))
        }
        .frame(height: 200)
        .padding()
        .animation(.linear(duration: updateInterval), value: progress)
    }
}

#Preview {
    TimerCircleView(progress: 0.4, accentColor: .redAccent, updateInterval: 5.0)
}
