//
//  AuthorizationView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct AuthorizationView: View {
    @ObservedObject var model: AppBlockerModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Screen Time Permission Required")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("This app needs Screen Time permissions to block apps. Tap the button below to grant permission.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: requestPermission) {
                Text("Grant Permission")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func requestPermission() {
        Task {
            await model.requestAuthorization()
        }
    }
}

#Preview {
    AuthorizationView(model: AppBlockerModel())
}
