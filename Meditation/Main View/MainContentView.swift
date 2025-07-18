//
//  MainContentView.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var model: TheModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                MainViewButton(label: "App Blocker", iconName: "shield.fill", labelColor: .greenAccent, action: model.navigateToAppBlocker)
                Spacer()
                MainViewButton(label: "Meditation", iconName: "circle.fill", labelColor: .redAccent, action: model.navigateToMeditation)
                Spacer()
            }
        }
        .navigationTitle("○")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainContentView(model: TheModel())
    }
}
