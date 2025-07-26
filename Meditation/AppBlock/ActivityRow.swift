//
//  ActivityRow.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import SwiftUI

struct ActivityRow: View {
    let activity: AlternativeActivity
    let isSelected: Bool
    let isEditMode: Bool
    let onToggle: () -> Void
    let onDelete: () -> Void
    let onEdit: () -> Void

    var body: some View {
        HStack {
            if !isEditMode {
                HStack {
                    ZStack {
                        Text("🥰")
                            .opacity(0)
                        Text(activity.symbol ?? "○")
                    }
                    
                    .font(.title)
                    .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(activity.name)
                        Text(description(for: activity.action))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? .greenAccent : .gray.opacity(0.3))
                }
                .contentShape(Rectangle())
                .onTapGesture { onToggle() }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                
            } else {
                Group {
                    ZStack {
                        Text("🥰")
                            .opacity(0)
                        Text(activity.symbol ?? "○")
                    }
                    
                    .font(.title)
                    .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(activity.name)
                        Text(description(for: activity.action))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        onEdit()
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Button {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func description(for action: AlternativeAction) -> String {
        switch action {
        case .openApp(let bundleID):
            return "Opens app: \(bundleID)"
        case .openInApp(let identifier):
            return "Opens in 7III Life: \(identifier)"
        case .closeApp(let message):
            return "Closes app with message: \(message)"
        case .openWebsite(URL: let URL):
            return "Opens website: \(URL)"
        }
    }
}

#Preview {
    ActivityRow(activity: AlternativeActivity(name: "Testing", action: .closeApp(message: "Hasta la Vista"), symbol: "👋"), isSelected: true, isEditMode: true, onToggle: {}, onDelete: {}, onEdit: {})
}
