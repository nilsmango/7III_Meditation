//
//  WidgetButtonStyle.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import SwiftUI

struct WidgetButtonStyle: ViewModifier {
    var frameWidth: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.title)
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.circle)
            .tint(.accent)
            .frame(width: frameWidth)
    }
}

extension View {
    func widgetButtonStyle(frameWidth: CGFloat) -> some View {
        self.modifier(WidgetButtonStyle(frameWidth: frameWidth))
    }
}
