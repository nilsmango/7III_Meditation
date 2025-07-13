//
//  MainContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var model: AppBlockerModel
    @State private var showingFamilyPicker = false
    @State private var showTopUpSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            if model.hasSelectedApps {
                Button {
                    showTopUpSheet = true
                } label: {
                    Label("Top up Time", systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                }
                .buttonStyle(.bordered)
                
                SelectedAppsView(model: model)
            }
            
            AppSelectionButton(showingFamilyPicker: $showingFamilyPicker, model: model)
            
            if model.hasSelectedApps {
                BlockingToggleButton(model: model)
            }
            
            StatusView(model: model)
        }
        .familyActivityPicker(isPresented: $showingFamilyPicker, selection: $model.selection)
        .sheet(isPresented: $showTopUpSheet) {
            TopUpTimeView(model: model, showSheet: $showTopUpSheet)
        }
        .onChange(of: model.selection) {
            model.enableBlocking()
        }
    }
}

#Preview {
    MainContentView(model: AppBlockerModel())
}
