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
    @State private var showingAlternativesPicker = false
    @State private var alternativesSelection: [AlternativeActivity] = []
    
    // for some soft sync
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    
                    if model.howToButton {
                        HowToButton()
                    }
                    
                                    
                    if model.hasSelectedApps || model.hasSelectedWebsites {
                        NavigationLink {
                            TopUpTimeView(model: model)
                        } label: {
                            ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .greenAccent, navigationLink: true)
                        }
                    }
                    SelectedAppsView(model: model)
                                        
                    Button {
                        showingFamilyPicker = true
                    } label: {
                        ButtonLabel(iconName: model.hasSelectedApps ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedApps ? "Change selected Apps" : "Select Apps to Block", accentColor: .blue)
                    }
                    
                    Button {
                        showingWebsitePicker = true
                    } label: {
                        ButtonLabel(iconName: model.hasSelectedWebsites ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedWebsites ? "Change selected Websites" : "Select Websites to Block", accentColor: .blue)
                    }
                    
                    if model.useAlternativeActivities {
                        Button {
                             showingAlternativesPicker = true
                        } label: {
                            ButtonLabel(iconName: model.hasSelectedAlternatives ? "arrow.2.squarepath" : "plus.app.fill", labelText: model.hasSelectedAlternatives ? "Change selected Alternatives" : "Select Alternatives", accentColor: .blue)
                        }
                    }
                    
                    
                    if model.hasSelectedApps || model.hasSelectedWebsites {
                        Button {
                            model.toggleBlocking()
                        } label: {
                            ButtonLabel(iconName: model.isBlocked ? "shield.slash.fill" : "shield.fill", labelText: model.isBlocked ? "Disable Blocking" : "Enable Blocking", accentColor: model.isBlocked ? .red : .green, fullColorButton: true)
                        }
                    }
                    
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
        .sheet(isPresented: $showingAlternativesPicker) {
            VStack(spacing: 0) {
                ActivitySelectionSheet(selectedActivities: $alternativesSelection)
                
                HStack {
                    
                    Button {
                        alternativesSelection = model.alternativesSelection
                        showingAlternativesPicker = false
                    } label: {
                        Label("Cancel", systemImage: "xmark.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        model.alternativesSelection = alternativesSelection
                        showingAlternativesPicker = false
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
            model.loadUserDefaults()
            selection = model.selection
            blockedWebsites = model.websitesSelection
            alternativesSelection = model.alternativesSelection
        }
        // for some soft sync
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                model.loadUserDefaults()
                selection = model.selection
                blockedWebsites = model.websitesSelection
                alternativesSelection = model.alternativesSelection
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(model: model)
                } label: {
                    Image(systemName: "ellipsis.circle.fill")
                        .font(.title3)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blackWhite, .greenAccent)
                }
                

            }
        }
        .navigationTitle("App Blocker")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AppBlockerView(model: TheModel())
    }
}
