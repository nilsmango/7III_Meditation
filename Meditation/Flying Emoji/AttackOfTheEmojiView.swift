//
//  AttackOfTheEmojiView.swift
//  Meditation
//
//  Created by Simon Lang on 01.06.2024.
//

import SwiftUI

struct AttackOfTheEmojiView: View {
    let xOffset: CGFloat = UIScreen.main.bounds.width / 2
    
    var emojis: [UUID]
    var emoji: String
    
    var body: some View {
        ZStack {
            ForEach(emojis, id: \.self) { id in
                FlyingEmojiView(emoji: emoji, duration: Double.random(in: 2.0...6.0), xOffset: Double.random(in: -xOffset...xOffset), delay: Double.random(in: 0.4...1.0))
                        }
        }
//        .onAppear {
//            for _ in 0..<10 {
//                        emojis.append(UUID())
//                    }
//        }
        
    }
}

#Preview {
    AttackOfTheEmojiView(emojis: [], emoji: "🔥")
}
