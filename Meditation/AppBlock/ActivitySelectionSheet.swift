//
//  ActivitySelectionSheet.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import SwiftUI

struct ActivitySelectionSheet: View {
    @ObservedObject var model: TheModel
    @Binding var selectedActivities: [AlternativeActivity]
    @State private var showingAddSheet = false
    @State private var showingEditSheet = false
    @State private var editingActivity: AlternativeActivity?
    @State private var newName = ""
    @State private var selectedType: AlternativeActionType = .closeApp
    @State private var stringValue = ""
    @State private var symbol: String? = nil
    @Binding var isEditMode: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Alternatives")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    resetSheetInputs()
                    editingActivity = nil
                    showingAddSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.greenAccent)
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
            }
            .padding()

            Divider()

            List {
                ForEach(model.allAlternatives) { activity in
                    ActivityRow(
                        activity: activity,
                        isSelected: selectedActivities.contains(where: { $0.name == activity.name }),
                        isEditMode: isEditMode,
                        onToggle: { toggleActivity(activity) },
                        onDelete: { deleteActivity(activity) },
                        onEdit: { editActivity(activity) }
                    )
                }
            }
            .listStyle(.plain)
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                AddActivitySheet(newName: $newName, selectedType: $selectedType, stringValue: $stringValue, symbol: $symbol)
                    .navigationTitle("Edit Activity")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                updateActivity()
                                showingEditSheet = false
                                isEditMode = false
                            }
                            .tint(.greenAccent)
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingEditSheet = false
                                isEditMode = false
                            }
                        }
                    }
            }
        }
        
        .sheet(isPresented: $showingAddSheet) {
            NavigationView {
                AddActivitySheet(newName: $newName, selectedType: $selectedType, stringValue: $stringValue, symbol: $symbol)
                    .navigationTitle("New Activity")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addCustomActivity()
                                showingAddSheet = false
                            }
                            .tint(.greenAccent)
                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddSheet = false
                            }
                        }
                    }
            }
        }
    }

    private func toggleActivity(_ activity: AlternativeActivity) {
        if let index = selectedActivities.firstIndex(where: { $0.id == activity.id }) {
            selectedActivities.remove(at: index)
        } else {
            selectedActivities.append(activity)
        }
    }

    private func resetSheetInputs() {
        newName = ""
        selectedType = .closeApp
        stringValue = ""
        symbol = nil
    }

    private func editActivity(_ activity: AlternativeActivity) {
        editingActivity = activity
        newName = activity.name
        symbol = activity.symbol
        
        // Set the type and string value based on the action
        switch activity.action {
        case .openApp(let appLink):
            selectedType = .openApp
            stringValue = appLink
        case .openWebsite(let URL):
            selectedType = .openWebsite
            stringValue = URL
        case .openInApp(let identifier):
            selectedType = .openInApp
            stringValue = identifier
        case .closeApp(let message):
            selectedType = .closeApp
            stringValue = message
        }
        
        showingEditSheet = true
    }

    private func addCustomActivity() {
        let trimmedName = newName.trimmingCharacters(in: .whitespaces)
        let trimmedValue = stringValue.trimmingCharacters(in: .whitespaces)

        let action: AlternativeAction
        switch selectedType {
        case .openApp:
            action = .openApp(appLink: trimmedValue)
        case .openWebsite:
            action = .openWebsite(URL: trimmedValue)
        case .openInApp:
            action = .openInApp(identifier: trimmedValue)
        case .closeApp:
            action = .closeApp(message: trimmedValue)
        }

        let activity = AlternativeActivity(name: trimmedName, action: action, symbol: symbol)
        model.allAlternatives.append(activity)
        selectedActivities.append(activity)
    }

    private func updateActivity() {
        guard let editingActivity = editingActivity else { return }
        
        let trimmedName = newName.trimmingCharacters(in: .whitespaces)
        let trimmedValue = stringValue.trimmingCharacters(in: .whitespaces)

        let action: AlternativeAction
        switch selectedType {
        case .openApp:
            action = .openApp(appLink: trimmedValue)
        case .openWebsite:
            action = .openWebsite(URL: trimmedValue)
        case .openInApp:
            action = .openInApp(identifier: trimmedValue)
        case .closeApp:
            action = .closeApp(message: trimmedValue)
        }

        let updatedActivity = AlternativeActivity(id: editingActivity.id, name: trimmedName, action: action, symbol: symbol)
        
        // Update in allActivities
        if let index = model.allAlternatives.firstIndex(where: { $0.id == editingActivity.id }) {
            model.allAlternatives[index] = updatedActivity
        }
        
        // Update in selectedActivities if it was selected
        if let index = selectedActivities.firstIndex(where: { $0.id == editingActivity.id }) {
            selectedActivities[index] = updatedActivity
            
            // Also update the real selection then
            if let index = model.alternativesSelection.firstIndex(where: { $0.id == editingActivity.id }) {
                model.alternativesSelection[index] = updatedActivity
            }
        }
        
        self.editingActivity = nil
    }

    private func deleteActivity(_ activity: AlternativeActivity) {
        model.allAlternatives.removeAll { $0.id == activity.id }
        selectedActivities.removeAll { $0.id == activity.id }
        model.alternativesSelection.removeAll { $0.id == activity.id }
    }
}

#Preview {
    ActivitySelectionSheet(model: TheModel(), selectedActivities: .constant([]), isEditMode: .constant(false))
}
