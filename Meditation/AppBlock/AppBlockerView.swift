//
//  AppBlockerView.swift
//  Meditation
//
//  Created by Simon Lang on 14.07.2025.
//

import SwiftUI
import FamilyControls

struct AppBlockerView: View {
    @ObservedObject var model: TheModel
    @State private var showingFamilyPicker = false
    @State private var selection = FamilyActivitySelection()
    @State private var showingWebsitePicker = false
    @State private var blockedWebsites: [String] = []
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    HowToButton()
                                    
                    if model.hasSelectedApps || model.hasSelectedWebsites {
                        NavigationLink {
                            TopUpTimeView(model: model)
                        } label: {
                            ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .greenAccent, navigationLink: true)
                        }
                        
                        SelectedAppsView(model: model)
                    }
                                        
                    Button {
                        showingFamilyPicker = true
                    } label: {
                        ButtonLabel(iconName: model.hasSelectedApps ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedApps ? "Change Selected Apps" : "Select Apps to Block", accentColor: .blue)
                    }
                    
                    Button {
                        showingWebsitePicker = true
                    } label: {
                        ButtonLabel(iconName: model.hasSelectedWebsites ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedWebsites ? "Change Selected Websites" : "Select Websites to Block", accentColor: .blue)
                    }
                    
                    
                    if model.hasSelectedApps {                        
                        Button {
                            model.toggleBlocking()
                        } label: {
                            ButtonLabel(iconName: model.isBlocked ? "shield.slash.fill" : "shield.fill", labelText: model.isBlocked ? "Disable Blocking" : "Enable Blocking", accentColor: model.isBlocked ? .red : .green, fullColorButton: true)
                        }
                    }
                    
                    StatusView(model: model)
                    
                    Spacer()
                }
                
            }
        .padding()
        .sheet(isPresented: $showingFamilyPicker) {
                VStack(spacing: 0) {
                    FamilyActivityPickerView(selection: $selection)
                        
                    HStack {
                        Button {
                            selection = model.selection
                            showingFamilyPicker = false
                        } label: {
                            Label("Cancel", systemImage: "xmark.circle.fill")
                        }
                        .tint(.red)
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button {
                            model.selection = selection
                            showingFamilyPicker = false
                        } label: {
                            Label("Update", systemImage: "checkmark.circle.fill")
                        }
                        .tint(.greenAccent)
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                .background(.activityBackground)
        }
        .sheet(isPresented: $showingWebsitePicker) {
            VStack(spacing: 0) {
                WebsiteSelectionSheet(blockedWebsites: $blockedWebsites)
                
                HStack {
                    
                    Button {
                        blockedWebsites = model.websitesSelection
                        showingWebsitePicker = false
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        model.websitesSelection = blockedWebsites
                        showingWebsitePicker = false
                    } label: {
                        Label("Update", systemImage: "checkmark.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.greenAccent)
                    
                }
                .padding()
            }
        }
        .onAppear {
            selection = model.selection
            blockedWebsites = model.websitesSelection
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // TODO: options
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blackWhite, .greenAccent)
                }
                

            }
        }
        .navigationTitle("App Blocker")
    }
}

#Preview {
    NavigationStack {
        AppBlockerView(model: TheModel())
    }
}
