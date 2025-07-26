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
    @State private var activityEditMode = false
    
    @State private var group1Activities: [AlternativeActivity] = []
    @State private var group2Activities: [AlternativeActivity] = []
    @State private var lilMessage: String? = nil
    
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
                            if model.useAlternativeActivities {
                                
                                AlternativeActionView(model: model, group1Activities: group1Activities, group2Activities: group2Activities)
                            } else {
                                TopUpTimeView(model: model)
                            }
                            
                        } label: {
                            ButtonLabel(iconName: "plus.circle.fill", labelText: "Top up Time", accentColor: .greenAccent, navigationLink: true)
                        }
                    }
                    SelectedAppsView(model: model)
                    
                    HStack {
                        Button {
                            showingFamilyPicker = true
                        } label: {
                            ButtonLabel(iconName: model.hasSelectedApps ? "arrow.2.squarepath" : "plus.app.fill", labelText: "Apps", accentColor: .blue)
                        }
                        
                        Button {
                            showingWebsitePicker = true
                        } label: {
                            ButtonLabel(iconName: model.hasSelectedWebsites ? "arrow.2.squarepath" : "plus.app.fill", labelText: "Websites", accentColor: .blue)
                        }
                    }
                    
                    if model.useAlternativeActivities {
                        Button {
                             showingAlternativesPicker = true
                        } label: {
                            ButtonLabel(iconName: model.hasSelectedAlternatives ? "arrow.2.squarepath" : "plus.app.fill", labelText: "Alternatives", accentColor: .indigo)
                        }
                    }
                    
                    
                    if (model.hasSelectedApps || model.hasSelectedWebsites) && model.isBlocked == false {
                        Button {
                            model.toggleBlocking()
                            
                            withAnimation {
                                lilMessage = "Want to stop blocking? Just head to Settings (top right corner)."
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                withAnimation {
                                    lilMessage = nil
                                }
                            }
                        } label: {
                            ButtonLabel(iconName: "power", labelText: "Start Blocking", accentColor: .greenAccent, fullColorButton: true)
                        }
                    } else if lilMessage != nil {
                        
                        HStack {
                            Image(systemName: "info.circle")
                            Text(lilMessage!)
                        }
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.buttonGray)
                        .cornerRadius(10)
                        .font(.headline)
                        .transition(.slide)
                        .onTapGesture {
                            withAnimation {
                                lilMessage = nil
                            }
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
                            showingFamilyPicker = false
                        } label: {
                            Text("Cancel")
                        }
                        .tint(.red)
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button {
                            model.selection = selection
                            showingFamilyPicker = false
                        } label: {
                            Text("Update")
                        }
                        .tint(.greenAccent)
                        .buttonStyle(.bordered)
                    }
                    .padding()
                }
                .background(.activityBackground)
                .onDisappear {
                    if showingFamilyPicker == false {
                        selection = model.selection
                    }
                }
        }
        .sheet(isPresented: $showingWebsitePicker) {
            VStack(spacing: 0) {
                WebsiteSelectionSheet(model: model, blockedWebsites: $blockedWebsites)
                
                HStack {
                    Button {
                        showingWebsitePicker = false
                    } label: {
                        Text("Cancel")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        model.websitesSelection = blockedWebsites
                        showingWebsitePicker = false
                    } label: {
                        Text("Update")
                    }
                    .buttonStyle(.bordered)
                    .tint(.greenAccent)
                    
                }
                .padding()
            }
            .onDisappear {
                if showingWebsitePicker == false {
                    blockedWebsites = model.websitesSelection
                }
            }
        }
        .sheet(isPresented: $showingAlternativesPicker) {
            VStack(spacing: 0) {
                ActivitySelectionSheet(model: model, selectedActivities: $alternativesSelection, isEditMode: $activityEditMode)
                
                HStack {
                    Button {
                        showingAlternativesPicker = false
                    } label: {
                        Text("Cancel")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        activityEditMode.toggle()
                    } label: {
                        Text(activityEditMode ? "Done" : "Edit Mode")
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    
                    Spacer()
                    
                    Button {
                        model.alternativesSelection = alternativesSelection
                        showingAlternativesPicker = false
                    } label: {
                        Text("Update")
                    }
                    .buttonStyle(.bordered)
                    .tint(.greenAccent)
                    
                }
                .padding()
            }
            .onDisappear {
                if showingAlternativesPicker == false {
                    alternativesSelection = model.alternativesSelection
                }
            }
        }
        .onAppear {
            model.loadUserDefaults()
            selection = model.selection
            blockedWebsites = model.websitesSelection
            alternativesSelection = model.alternativesSelection
            
            if model.useAlternativeActivities {
                let AlternativeGroups = model.makeRandomAlternativeGroups()
                group1Activities = AlternativeGroups.0
                group2Activities = AlternativeGroups.1
            }
            
        }
        .onChange(of: model.alternativesSelection) {
            let AlternativeGroups = model.makeRandomAlternativeGroups()
            group1Activities = AlternativeGroups.0
            group2Activities = AlternativeGroups.1
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
