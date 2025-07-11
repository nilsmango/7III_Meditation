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
            Image(systemName: "shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            
            Text("App Blocker")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Block distracting apps and redirect to this app")
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
