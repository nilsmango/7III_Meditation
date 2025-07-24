//
//  MacTopUpTimeView.swift
//  LifeMac
//
//  Created by Simon Lang on 23.07.2025.
//

import SwiftUI

struct MacTopUpTimeView: View {
    @ObservedObject var model: MacModel
    @State private var showCheckmark = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            
            if showCheckmark {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.green)
                    .transition(.scale)
                Text("You can now unlock your website!")
                    .font(.title3)
                    .fontWeight(.semibold)
            } else {
              
                Picker("Time", selection: $model.topUpMinutes) {
                    // 1-90 minutes
                    ForEach(1...90, id: \.self) { minute in
                        Text("\(minute) min").tag(minute)
                    }
                    
                    // Hours converted to minutes
                    Text("2 h").tag(120)  // 2 hours = 120 minutes
                    Text("3 h").tag(180)  // 3 hours = 180 minutes
                    Text("4 h").tag(240)  // 4 hours = 240 minutes
                    Text("8 h").tag(480)  // 8 hours = 480 minutes
                    Text("16 h").tag(960) // 16 hours = 960 minutes
                    Text("24 h").tag(1440) // 24 hours = 1440 minutes
                }
                .pickerStyle(.menu)
                .frame(width: 140)
                .padding(.bottom, 9)
                HStack {
                    
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .keyboardShortcut(.cancelAction)
                    .padding(.trailing, 6)
                    
                    Button {
                        model.topUpTime()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCheckmark = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            dismiss()
                        }
                    } label: {
                        Label("Top Up", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .keyboardShortcut(.defaultAction)
                    .tint(.greenAccent)
                    
                }
            }
        }
        .padding()
        .frame(width: 250, height: 150)
        .onAppear {
            model.topUpMinutes = 1
        }
    }
}

#Preview {
    MacTopUpTimeView(model: MacModel())
}
