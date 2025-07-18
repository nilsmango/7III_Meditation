//
//  SelectedAppsView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

import SwiftUI

struct SelectedAppsView: View {
    @ObservedObject var model: TheModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Selected Apps (\(model.selectedAppsCount)), Websites (\(model.selectedWebsitesCount))")
                .font(.headline)
            
            Text("Apps selected for blocking")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    SelectedAppsView(model: TheModel())
}
