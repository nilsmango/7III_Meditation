//
//  LifeMacApp.swift
//  LifeMac
//
//  Created by Simon Lang on 21.07.2025.
//

import SwiftUI

@main
struct LifeMacApp: App {
    @StateObject private var model = MacModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(model: model)
        }
    }
}
