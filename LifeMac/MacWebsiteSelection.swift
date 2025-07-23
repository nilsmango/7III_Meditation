//
//  MacWebsiteSelection.swift
//  LifeMac
//
//  Created by Simon Lang on 23.07.2025.
//

import SwiftUI

struct MacWebsiteSelection: View {
    @ObservedObject var model: MacModel

    @State private var blockedWebsites: [String] = []
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            WebsiteSelectionSheet(blockedWebsites: $blockedWebsites)

            HStack {
                Spacer()
                
                Button("Cancel") {
                    blockedWebsites = model.websitesSelection
                    dismiss()
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .keyboardShortcut(.cancelAction)
                .padding(.trailing, 6)
                
                Button {
                    model.websitesSelection = blockedWebsites
                    dismiss()
                } label: {
                    Text("Save")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .keyboardShortcut(.defaultAction)
                .tint(.greenAccent)
                .disabled(model.websitesSelection == blockedWebsites)
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            blockedWebsites = model.websitesSelection
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MacWebsiteSelection(model: MacModel())
}
