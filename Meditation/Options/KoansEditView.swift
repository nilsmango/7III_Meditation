//
//  KoansEditView.swift
//  Meditation
//
//  Created by Simon Lang on 26.05.2024.
//

import SwiftUI

struct KoansEditView: View {
    @ObservedObject var meditationManager: MeditationManager

    @State private var newKoan = ""
    var body: some View {
        List {
            ForEach(meditationManager.meditationTimer.koans, id: \.self) { koan in
                Text(koan)
            }
                .onDelete { indices in
                    meditationManager.deleteKoan(at: indices)
                }
            TextField("Add Koan", text: $newKoan)
                .onSubmit {
                    meditationManager.addKoan(text: newKoan)
                    newKoan = ""
                }
        }
        .scrollContentBackground(.hidden)
        .background(.customGray)
        .navigationBarItems(trailing: EditButton())
    }
}

#Preview {
    KoansEditView(meditationManager: MeditationManager())
}
