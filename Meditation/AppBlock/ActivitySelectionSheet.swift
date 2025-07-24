//
//  ActivitySelectionSheet.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import SwiftUI

struct ActivitySelectionSheet: View {
    @Binding var selectedActivities: [AlternativeActivity]
    @State private var allActivities: [AlternativeActivity] = []
    @State private var showingAddSheet = false
    @State private var newName = ""
    @State private var selectedType: AlternativeActionType = .closeApp
    @State private var stringValue = ""

    private let predefinedActivities: [AlternativeActivity] = [
        .init(name: "Meditate", action: .openInApp(identifier: "meditation")),
        .init(name: "Read a Book", action: .openApp(bundleID: "com.apple.books")),
        .init(name: "Take a Nap", action: .openApp(bundleID: "com.apple.mobiletimer")),
        .init(name: "Talk to Someone", action: .openApp(bundleID: "net.whatsapp.WhatsApp")),
        .init(name: "Watch a Movie", action: .closeApp(message: "Enjoy the movie!")),
        .init(name: "Make Music", action: .closeApp(message: "Time to jam!")),
        .init(name: "Work on To-Do's", action: .openApp(bundleID: "com.apple.reminders"))
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Alternative Activities")
                    .font(.title2)
                    .fontWeight(.semibold)

                Spacer()

                Button {
                    resetSheetInputs()
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
                ForEach(allActivities, id: \.name) { activity in
                    ActivityRow(
                        activity: activity,
                        isSelected: selectedActivities.contains(where: { $0.name == activity.name }),
                        onToggle: { toggleActivity(activity) },
                        onDelete: { deleteActivity(activity) }
                    )
                }
            }
            .listStyle(.plain)
        }
        .onAppear(perform: loadActivities)
        .sheet(isPresented: $showingAddSheet) {
            NavigationStack {
                AddActivitySheet(newName: $newName, selectedType: $selectedType, stringValue: $stringValue)
                    .navigationTitle("New Activity")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addCustomActivity()
                                showingAddSheet = false
                            }
                            .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty ||
                                      stringValue.trimmingCharacters(in: .whitespaces).isEmpty)
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

    private func loadActivities() {
        allActivities = predefinedActivities

        for activity in selectedActivities where !allActivities.contains(where: { $0.name == activity.name }) {
            allActivities.append(activity)
        }
    }

    private func toggleActivity(_ activity: AlternativeActivity) {
        if let index = selectedActivities.firstIndex(where: { $0.name == activity.name }) {
            selectedActivities.remove(at: index)
        } else {
            selectedActivities.append(activity)
        }
    }

    private func resetSheetInputs() {
        newName = ""
        selectedType = .closeApp
        stringValue = ""
    }

    private func addCustomActivity() {
        let trimmedName = newName.trimmingCharacters(in: .whitespaces)
        let trimmedValue = stringValue.trimmingCharacters(in: .whitespaces)

        let action: AlternativeAction
        switch selectedType {
        case .openApp:
            action = .openApp(bundleID: trimmedValue)
        case .openWebsite:
            action = .openWebsite(URL: trimmedValue)
        case .openInApp:
            action = .openInApp(identifier: trimmedValue)
        case .closeApp:
            action = .closeApp(message: trimmedValue)
        }

        let activity = AlternativeActivity(name: trimmedName, action: action)
        allActivities.append(activity)
        selectedActivities.append(activity)
    }

    private func deleteActivity(_ activity: AlternativeActivity) {
        allActivities.removeAll { $0.name == activity.name }
        selectedActivities.removeAll { $0.name == activity.name }
    }
}

#Preview {
    ActivitySelectionSheet(selectedActivities: .constant([]))
}
