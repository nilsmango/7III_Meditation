//
//  AppSelectionButton.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct AppSelectionButton: View {
    @Binding var showingFamilyPicker: Bool
    @ObservedObject var model: AppBlockerModel
    
    var body: some View {
        Button(action: { showingFamilyPicker = true }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text(buttonText)
            }
            .font(.headline)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .padding(.horizontal)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private var buttonText: String {
        model.hasSelectedApps ? "Change Selected Apps" : "Select Apps to Block"
    }
}

#Preview {
    AppSelectionButton(showingFamilyPicker: .constant(false), model: AppBlockerModel())
}
