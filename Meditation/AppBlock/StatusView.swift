//
//  StatusView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var model: TheModel
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Circle()
                    .fill(model.blockingStatusColor)
                    .frame(width: 12, height: 12)
                
                Text(model.blockingStatusText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            
            if model.isBlocked {
                Text("Selected apps are now blocked. When you try to open them, you'll be redirected here.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}


#Preview {
    StatusView(model: TheModel())
}
