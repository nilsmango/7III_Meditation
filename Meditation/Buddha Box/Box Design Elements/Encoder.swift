//
//  Encoder.swift
//  Meditation
//
//  Created by Simon Lang on 04.10.2024.
//

import SwiftUI

struct Encoder: View {
    let dialSize: CGFloat
    let trimMax: CGFloat = 0.75
    let maxValue: Double
    let resetValue: Double
    let dialColor: Color
    let value: Double
    var encoderText: String
    
    private var lineWidth: Double {
        return dialSize * 8 / 70.0
    }
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: trimMax)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .bevel))
                .foregroundColor(dialColor.opacity(0.2))
                .rotationEffect(Angle(degrees: 135))
                .frame(width: dialSize, height: dialSize)
            
            switch resetValue {
            case 127/2:
                Triangle()
                    .frame(width: dialSize/10, height: dialSize/10)
                    .offset(y: -dialSize / 3 )
                    .opacity(0.2)
                
                switch value {
                case 0..<maxValue/2:
                    Circle()
                        .trim(from: value / maxValue * trimMax, to: trimMax/2)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .bevel))
                        .foregroundColor(dialColor)
                        .rotationEffect(Angle(degrees: 135))
                        .frame(width: dialSize, height: dialSize)
                case (maxValue/2).rounded():
                    Circle()
                        .opacity(0.0)
                        .frame(width: dialSize, height: dialSize)
                default:
                    Circle()
                        .trim(from: trimMax/2, to: value / maxValue * trimMax)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .bevel))
                        .foregroundColor(dialColor)
                        .rotationEffect(Angle(degrees: 135))
                        .frame(width: dialSize, height: dialSize)
                }
                default:
                Circle()
                    .trim(from: 0.0, to: value / maxValue * trimMax)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .bevel))
                    .foregroundColor(dialColor)
                    .rotationEffect(Angle(degrees: 135))
                    .frame(width: dialSize, height: dialSize)
                
            }
            Text(encoderText)
                .monospacedDigit()
                .font(.footnote)

//                .bold()
//                .font(.system(size: dialSize * 0.5))
//                .offset(y: dialSize / 3 )
        }
    }
}

#Preview {
    Encoder(dialSize: 60, maxValue: 100, resetValue: 0, dialColor: .green, value: 34, encoderText: "0.83")
}
