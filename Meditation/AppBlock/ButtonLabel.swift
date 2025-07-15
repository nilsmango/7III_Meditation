//
//  ButtonsLabel.swift
//  Meditation
//
//  Created by Simon Lang on 15.07.2025.
//

import SwiftUI

struct ButtonLabel: View {
    var iconName: String
    var labelText: String
    var accentColor: Color
    var backgroundColor: Color = .buttonGray
    var navigationLink: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundStyle(accentColor)
                
            Text(labelText)
                .fontWeight(.medium)
                .padding(.leading, 4)
            Spacer()
            Image(systemName: "chevron.forward")
                .opacity(navigationLink ? 1 : 0)
        }
        .foregroundColor(.primary)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .padding(.horizontal)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    ButtonLabel(iconName: "lightbulb.max.fill", labelText: "How To", accentColor: .yellow, navigationLink: true)
        .padding()
}
