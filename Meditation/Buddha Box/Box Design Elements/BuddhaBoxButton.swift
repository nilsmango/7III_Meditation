//
//  BuddhaBoxButton.swift
//  Meditation
//
//  Created by Simon Lang on 15.11.2024.
//

import SwiftUI

struct BuddhaBoxButton: View {
    var action: () -> Void
    var labelText: String
    var isFullOpacity: Bool
    var buttonFrameSize: CGSize
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(labelText)
                    .font(.caption)
                    .tint(.primary)
                
                Circle()
                    .fill(.redAccent.opacity(isFullOpacity ? 1.0 : 0.2))
                    .shadow(color: .black.opacity(0.1), radius: 10)
                    .frame(width: buttonFrameSize.width - 10, height: buttonFrameSize.height)
            }
        }
        .frame(width: buttonFrameSize.width)
    }
}

#Preview {
    BuddhaBoxButton(action: {}, labelText: "On", isFullOpacity: true, buttonFrameSize: CGSize(width: 60, height: 60))
}
