//
//  FlyingEmojiView.swift
//  Meditation
//
//  Created by Simon Lang on 01.06.2024.
//

import SwiftUI

struct FlyingEmojiView: View {
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    var emoji: String
    var duration: Double
    var xOffset: Double
    var delay: Double
        
        var body: some View {
            Text(emoji)
                .font(.largeTitle)
                .offset(x: xOffset, y: offset)
                .onAppear {
                    withAnimation(Animation.linear(duration: duration).delay(delay)) {
                        offset = -UIScreen.main.bounds.height
                    }
                }
        }
}

#Preview {
    FlyingEmojiView(emoji: "🔥", duration: 7.0, xOffset: 0.0, delay: 1.0)
}
