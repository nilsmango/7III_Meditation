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
                    .foregroundColor(.greenAccent)
                    .transition(.scale)
                Text("You can now unlock your app or website!")
                    .font(.title)
                    .fontWeight(.bold)
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + model.messageTime) {
                            model.navigateHome()
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
