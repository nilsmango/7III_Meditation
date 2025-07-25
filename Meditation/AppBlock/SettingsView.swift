//
//  SettingsView.swift
//  Meditation
//
//  Created by Simon Lang on 25.07.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var model: TheModel
    var body: some View {
        List {
            Section("Options") {
                Toggle("Show How To", isOn: $model.howToButton)
                    .tint(.greenAccent)
                Toggle("Use Alternative Activities", isOn: $model.useAlternativeActivities)
                    .tint(.greenAccent)
                Toggle("Easy Top Up Button", isOn: $model.easyTopUpButton)
                    .tint(.greenAccent)
            }
            Section {
                Button {
                    model.toggleBlocking()
                } label: {
                    HStack {
                        Spacer()
                        Label(model.isBlocked ? "Disable Blocking" : "Enable Blocking", systemImage: model.isBlocked ? "shield.slash.fill" : "shield.fill")
                        Spacer()
                    }
                    .foregroundStyle(.white)
                }
                .listRowBackground(model.isBlocked ? Color.red : Color.greenAccent)
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(model: TheModel())
    }
    
}
