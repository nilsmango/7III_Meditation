//
//  CircleButtonStyle.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct CircleButtonStyle: ButtonStyle {
//    var bgColor: Color
    var hugeCircle: Bool = true

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(.blackWhite)
            .padding(30)
            .background(
                ZStack {
                    Circle()
                        .fill(.accent.opacity(configuration.isPressed ? 0.3 : 1.0))
                }
//                    .scaleEffect(configuration.isPressed ? hugeCircle ? 5 : 1 : 1)
//                    .animation(.linear(duration: hugeCircle ? 2.0 : 0.8), value: configuration.isPressed)
                    .animation(.snappy(duration: 0.1), value: configuration.isPressed)
        )
    }
}
