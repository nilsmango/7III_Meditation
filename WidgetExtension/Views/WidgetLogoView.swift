//
//  WidgetLogoView.swift
//  Meditation
//
//  Created by Simon Lang on 30.05.2024.
//

import SwiftUI

struct WidgetLogoView: View {
    var expanded: Bool = false
    
    var body: some View {
        if expanded {
            Circle()
                .fill(.accent)
        } else {
            Circle()
                .fill(.accent)
                .frame(width: 25, height: 25)
        }
        
    }
}

#Preview {
    WidgetLogoView()
}
