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
        ZStack {
            Label(buttonState.rawValue.capitalized, systemImage: buttonState.symbolName)
                .fontWeight(.bold)
                .labelStyle(.iconOnly)
            
            if buttonState == .pause {
                Label("", systemImage: "xmark")
                    .fontWeight(.bold)
                    .labelStyle(.iconOnly)
                    .opacity(0.0)
            }
        }
        

    }
}

//#Preview {
//    WidgetButtonLabel(buttonState: .pause)
//}
