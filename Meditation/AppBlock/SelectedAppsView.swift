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
            Text("\(model.selectedAppsCount) \(model.selectedAppsCount == 1 ? "App" : "Apps") & \(model.selectedWebsitesCount) \(model.selectedWebsitesCount == 1 ? "Website" : "Websites") selected")
                .font(.headline)
            
            if model.useAlternativeActivities {
                Text("\(model.selectedAlternativesCount) \(model.selectedAlternativesCount == 1 ? "Alternative" : "Alternatives") defined")
                    .font(.headline)
            }
            
            HStack {
                Circle()
                    .fill(model.blockingStatusColor)
                    .frame(width: 12, height: 12)
                
                Text(model.blockingStatusText)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
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
