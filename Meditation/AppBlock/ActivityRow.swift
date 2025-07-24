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
    let onToggle: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack {
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
                .onTapGesture { onToggle() }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { onToggle() }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func description(for action: AlternativeAction) -> String {
        switch action {
        case .openApp(let bundleID):
            return "Open app: \(bundleID)"
        case .openInApp(let identifier):
            return "Open in 7III Life: \(identifier)"
        case .closeApp(let message):
            return "Close app with message: \(message)"
        case .openWebsite(URL: let URL):
            return "Open website: \(URL)"
        }
    }
}

#Preview {
    ActivityRow(activity: AlternativeActivity(name: "Testing", action: .closeApp(message: "Hasta la Vista")), isSelected: true, onToggle: {}, onDelete: {})
}
