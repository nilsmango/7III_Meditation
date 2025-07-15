//
//  HowToButton.swift
//  Meditation
//
//  Created by Simon Lang on 15.07.2025.
//

import SwiftUI

struct HowToButton: View {
    var body: some View {
        NavigationLink(destination: {
            HowToView()
        }) {
            ButtonLabel(iconName: "lightbulb.max.fill", labelText: "How To", accentColor: .yellow, navigationLink: true)
        }
    }
}

#Preview {
    HowToButton()
}
