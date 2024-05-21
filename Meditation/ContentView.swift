//
//  ContentView.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: OptionsView(meditationManager: meditationManager)) {
                            Label("Options", systemImage: "ellipsis.circle.fill")
                                .font(.title.weight(.ultraLight))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.blackWhite, .accent)
                                .labelStyle(.iconOnly)
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            
                        }
                    }
                    Spacer()
                    
                }
                TimerView(meditationManager: meditationManager)
            }
                .background(.customGray)
        }
        
    }
}

#Preview {
    ContentView(meditationManager: MeditationManager())
}
