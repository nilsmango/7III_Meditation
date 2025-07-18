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
    var fullColorButton: Bool = false
    
    var body: some View {
        HStack {
            if !navigationLink {
                Spacer()
            }
            Image(systemName: iconName)
                .foregroundStyle(fullColorButton ? .white : accentColor)
                
            Text(labelText)
                .padding(.leading, 4)
                .foregroundStyle(fullColorButton ? .white : navigationLink ? .primary : accentColor)
            
            Spacer()
            
            if navigationLink {
                Image(systemName: "chevron.forward")
            }
        }
        .foregroundColor(.primary)
        .font(.headline)
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        .padding(.horizontal)
        .background(fullColorButton ? accentColor : navigationLink ? backgroundColor : accentColor.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ButtonLabel(iconName: "lightbulb.max.fill", labelText: "How To", accentColor: .yellow, navigationLink: false, fullColorButton: true)
        .padding()
}
