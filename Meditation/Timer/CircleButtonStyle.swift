//
//  CircleButtonStyle.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
//    var bgColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .background(
                ZStack {
                    Circle()
                        .fill(.customGray)
                        .opacity(configuration.isPressed ? 0.75 : 1.0)
                        
                }
                .scaleEffect(configuration.isPressed ? 1.3 : 1)
                .animation(.easeOut, value: configuration.isPressed)
        )
    }
}
