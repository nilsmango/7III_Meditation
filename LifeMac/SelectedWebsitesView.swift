//
//  SelectedWebsitesView.swift
//  LifeMac
//
//  Created by Simon Lang on 21.07.2025.
//

import SwiftUI

struct SelectedWebsitesView: View {
    @ObservedObject var model: MacModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(model.selectedWebsitesCount) \(model.selectedWebsitesCount == 1 ? "Website" : "Websites") selected")
                .font(.headline)
            
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
    SelectedWebsitesView(model: MacModel())
}
