//
//  TopUpTimeView.swift
//  Meditation
//
//  Created by Simon Lang on 13.07.2025.
//

import SwiftUI

struct TopUpTimeView: View {
    @ObservedObject var model: AppBlockerModel
    @State private var showCheckmark = false
    @Binding var showSheet: Bool

    var body: some View {
        VStack(spacing: 20) {
            

            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.green)
                    .transition(.scale)
                Text("You can now unlock your app!")
                    .font(.title)
                    .fontWeight(.bold)
            } else {
                
                Picker("Minutes", selection: $model.topUpMinutes) {
                    ForEach(1...180, id: \.self) { minute in
                        Text("\(minute) min")
                    }
                }
                .pickerStyle(.wheel)
                
                Button {
                    model.topUpTime()
                    withAnimation {
                        showCheckmark = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showSheet = false
                    }
                } label: {
                    Label("Top Up", systemImage: "checkmark")
                }
                .buttonStyle(.bordered)
                
                Button {
                    showSheet = false
                } label: {
                    Label("Cancel", systemImage: "xmark")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
}

#Preview {
    TopUpTimeView(model: AppBlockerModel(), showSheet: .constant(true))
}
