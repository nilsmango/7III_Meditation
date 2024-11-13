//
//  Dial.swift
//  Meditation
//
//  Created by Simon Lang on 13.11.2024.
//

import SwiftUI

struct Dial: View {
    @Binding var value: Double
    
    @State private var oldVerticalDragDistance = 0.0
    @State private var oldHorizontalDragDistance = 0.0
    
    private let maxValue = 100.0
    
    // dial circle
    private let trimMax = 0.75
    var resetValue: Double = 0.0
    let dialColor: Color
    var dialName: String = "Macro"
    var encoderText: String = ""
    
    // dial size animation
    @State private var dialSize: CGFloat = 60
    var dialFrameSize: CGFloat = 60
    
    @State private var isDragging = false
    private let sizeFactor = 1.08
    private let animationDuration = 0.1
        
    var body: some View {
        VStack {
            if dialName == "" {
                Text("Dial")
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .opacity(0.0)
            } else {
                Text(dialName)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            
            
            Encoder(dialSize: dialSize, maxValue: maxValue, resetValue: resetValue, dialColor: dialColor, value: value, encoderText: encoderText)
                .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { dragValue in
                                if !isDragging {
                                    withAnimation(.linear(duration: animationDuration)) {
                                        dialSize *= sizeFactor
                                    }
                                    isDragging = true
                                }
                                // calculating the relative drag distance
                                let vertical = (-dragValue.translation.height - oldVerticalDragDistance) * 0.9
                                let horizontal = (dragValue.translation.width - oldHorizontalDragDistance) * 0.06
                                
                                // refreshing value
                                let dragSum = vertical + horizontal
                                if dragSum != 0.0 {
                                    let normalizedValue = max(0.0, min(maxValue, value + dragSum))
                                    withAnimation(.linear(duration: animationDuration)) {
                                        value = normalizedValue
                                    }
                                    oldVerticalDragDistance = -dragValue.translation.height
                                    oldHorizontalDragDistance = dragValue.translation.width
                                }
                                                                
                               
                            }
                            .onEnded { value in
                                withAnimation(.linear(duration: animationDuration)) {
                                    dialSize /= sizeFactor
                                }
                                isDragging = false
                                
                                // reseting our old drag values
                                oldVerticalDragDistance = 0.0
                                oldHorizontalDragDistance = 0.0
                            }

                            .simultaneously(with: SimultaneousGesture(TapGesture(count: 2), TapGesture(count: 3))
                                        .onEnded { gestureValue in

                                                if gestureValue.second != nil {
                                                    withAnimation(.linear(duration: animationDuration)) {
                                                        value = maxValue / 2
                                                    }

                                                } else if gestureValue.first != nil {
                                                    withAnimation(.linear(duration: animationDuration)) {
                                                        value = resetValue
                                                    }
                                                }
                                            }
                           )
                    )
                    .frame(width: dialFrameSize, height: dialFrameSize)
        }
        .onAppear {
            dialSize = dialFrameSize
        }
    }
}

struct Dial_Previews: PreviewProvider {
    static var previews: some View {
        Dial(value: .constant(12.2), resetValue: 0, dialColor: .green, dialName: "Filter")
    }
}
