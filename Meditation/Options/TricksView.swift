//
//  TricksView.swift
//  Meditation
//
//  Created by Simon Lang on 26.11.2024.
//

import SwiftUI

struct TricksView: View {
    var body: some View {
        List {
            Section(content: {
                Text("If you have an Apple Watch, deactivate mirroring iPhone notifications for 7III Meditation, as sometimes the end of meditation is not mirrored correctly to the Apple Watch (iOS bug).")
            }, header: {
                Text("Apple Watch")
            }
                    )
        }
        .scrollContentBackground(.hidden)
        .background(.customGray)
        .navigationTitle("Tips & Tricks")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TricksView()
}
