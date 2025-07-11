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
    
    var body: some View {
        VStack(spacing: 20) {
            if model.hasSelectedApps {
                SelectedAppsView(model: model)
            }
            
            AppSelectionButton(showingFamilyPicker: $showingFamilyPicker, model: model)
            
            if model.hasSelectedApps {
                BlockingToggleButton(model: model)
            }
            
            StatusView(model: model)
        }
        .familyActivityPicker(isPresented: $showingFamilyPicker, selection: $model.selection)
    }
}

#Preview {
    MainContentView(model: AppBlockerModel())
}
