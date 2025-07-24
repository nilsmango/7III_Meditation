//
//  WebsiteRow.swift
//  Meditation
//
//  Created by Simon Lang on 19.07.2025.
//

import SwiftUI

struct WebsiteRow: View {
    let website: String
    let isSelected: Bool
    let onToggle: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            // Website favicon placeholder and name
            HStack(spacing: 12) {
                // Favicon placeholder
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(Color.blue.opacity(0.1))
//                    .frame(width: 32, height: 32)
//                    .overlay {
//                        Image(systemName: "globe")
//                            .font(.system(size: 14))
//                            .foregroundColor(.blue)
//                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(website)
                }
                
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onToggle()
            }
            
            // Selection indicator
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(isSelected ? .greenAccent : .gray.opacity(0.3))
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

#Preview {
    WebsiteRow(website: "youtube.com", isSelected: false, onToggle: {}, onDelete: {})
}
