//
//  HeaderView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "circle")
                .font(.system(size: 60))
            
            Text("7III Life")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Get your Life back")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }
}

#Preview {
    HeaderView()
}
