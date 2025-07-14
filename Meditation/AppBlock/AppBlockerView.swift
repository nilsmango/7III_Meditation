//
//  AppBlockerView.swift
//  Meditation
//
//  Created by Simon Lang on 14.07.2025.
//

import SwiftUI

struct AppBlockerView: View {
    @ObservedObject var model: AppBlockerModel
    @State private var showingFamilyPicker = false
    @State private var showTopUpSheet = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    model.navigateHome()
                } label: {
                    Label("Home", systemImage: "house.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.blackWhite, .greenAccent)
                        .labelStyle(.iconOnly)
                }
                
                Spacer()
            }
            Spacer()
            
            HeaderView()
            
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
            
            Spacer()
        }
        .padding()
        .familyActivityPicker(isPresented: $showingFamilyPicker, selection: $model.selection)
        .sheet(isPresented: $showTopUpSheet) {
            TopUpTimeView(model: model, showSheet: $showTopUpSheet)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        AppBlockerView(model: AppBlockerModel())
    }
}
