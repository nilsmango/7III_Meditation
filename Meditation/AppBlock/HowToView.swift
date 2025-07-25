//
//  HowToView.swift
//  Meditation
//
//  Created by Simon Lang on 15.07.2025.
//

import SwiftUI

struct HowToView: View {
    var body: some View {
        ScrollView {
            Text("How To")
        }
        .navigationTitle("How To")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HowToView()
    }
}
