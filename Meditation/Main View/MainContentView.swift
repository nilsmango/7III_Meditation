//
//  MainContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var model: AppBlockerModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                MainViewButton(label: "App Blocker", iconName: "shield.fill", labelColor: .greenAccent, action: model.navigateToAppBlocker)
                Spacer()
                MainViewButton(label: "Meditation", iconName: "circle.fill", labelColor: .accent, action: model.navigateToMeditation)
                Spacer()
            }
        }
    }
}

#Preview {
    MainContentView(model: AppBlockerModel())
        .padding()
}
