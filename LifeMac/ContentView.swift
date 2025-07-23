//
//  ContentView.swift
//  LifeMac
//
//  Created by Simon Lang on 21.07.2025.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: MacModel
    
    var body: some View {
        NavigationStack {
            WebBlockerView(model: model)
        }
    }
}

#Preview {
    ContentView(model: MacModel())
}
