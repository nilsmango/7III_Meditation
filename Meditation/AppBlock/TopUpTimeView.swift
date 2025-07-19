//
//  TopUpTimeView.swift
//  Meditation
//
//  Created by Simon Lang on 13.07.2025.
//

import SwiftUI

struct TopUpTimeView: View {
    @ObservedObject var model: TheModel
    @State private var showCheckmark = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            
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
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                        
                    } label: {
                        Text("Cancel")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button {
                        model.topUpTime()
                        withAnimation {
                            showCheckmark = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    } label: {
                        Label("Top Up", systemImage: "plus.circle.fill")
                    }
                    .buttonStyle(.bordered)
                    .tint(.greenAccent)
                    
                    Spacer()
                }
                
            }
        }
        .padding()
        .onAppear {
            model.topUpMinutes = 1
        }
    }
}

#Preview {
    TopUpTimeView(model: TheModel())
}
