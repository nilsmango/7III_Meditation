//
//  NoteView.swift
//  Meditation
//
//  Created by Simon Lang on 01.12.2024.
//

import SwiftUI

struct NoteView: View {
    var note: String
    var body: some View {
        VStack {
            Text(note)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding(.top, 70)
        .padding(.horizontal)
    }
}

#Preview {
    NoteView(note: "Note")
}
