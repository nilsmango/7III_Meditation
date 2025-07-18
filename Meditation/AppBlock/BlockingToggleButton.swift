//
//  BlockingToggleButton.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct BlockingToggleButton: View {
    @ObservedObject var model: TheModel
    
    var body: some View {
        Button(action: model.toggleBlocking) {
            HStack {
                Image(systemName: iconName)
                Text(buttonText)
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
        }
    }
    
    private var iconName: String {
        model.isBlocked ? "shield.slash.fill" : "shield.fill"
    }
    
    private var buttonText: String {
        model.isBlocked ? "Disable Blocking" : "Enable Blocking"
    }
    
    private var backgroundColor: Color {
        model.isBlocked ? .red : .green
    }
}

#Preview {
    BlockingToggleButton(model: TheModel())
}
