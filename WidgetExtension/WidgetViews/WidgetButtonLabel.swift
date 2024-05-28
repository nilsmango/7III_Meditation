//
//  WidgetButtonLabel.swift
//  WidgetExtensionExtension
//
//  Created by Simon Lang on 28.05.2024.
//

import SwiftUI

struct WidgetButtonLabel: View {
    let buttonState: WidgetButtonState
    
    var body: some View {
        Label(buttonState.rawValue.capitalized, systemImage: buttonState.symbolName)
            .fontWeight(buttonState == .pause ? .regular : .bold)
            .labelStyle(.iconOnly)

    }
}

#Preview {
    WidgetButtonLabel(buttonState: .pause)
}
