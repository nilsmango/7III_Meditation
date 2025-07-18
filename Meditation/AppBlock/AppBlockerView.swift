//
//  AppBlockerView.swift
//  Meditation
//
//  Created by Simon Lang on 14.07.2025.
//

import SwiftUI

struct AppBlockerView: View {
    @ObservedObject var model: TheModel
    @State private var showingFamilyPicker = false
    @State private var showTopUpSheet = false
    
    var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    HowToButton()
                                    
                    if model.hasSelectedApps {
                        Button {
                            showTopUpSheet = true
                        } label: {
                            ButtonLabel(iconName: "clock.arrow.trianglehead.counterclockwise.rotate.90", labelText: "Top up Time", accentColor: .greenAccent)
                        }
                        
                        SelectedAppsView(model: model)
                    }
                    
                    AppSelectionButton(showingFamilyPicker: $showingFamilyPicker, model: model)
                    
                    if model.hasSelectedApps {
                        BlockingToggleButton(model: model)
                    }
                    
                    StatusView(model: model)
                    
                    Spacer()
                }
                
            }
        .padding()
        .familyActivityPicker(isPresented: $showingFamilyPicker, selection: $model.selection)
        .sheet(isPresented: $showTopUpSheet) {
            TopUpTimeView(model: model, showSheet: $showTopUpSheet)
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
