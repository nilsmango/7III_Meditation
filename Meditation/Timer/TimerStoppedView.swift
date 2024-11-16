//
//  TimerStoppedView.swift
//  Meditation
//
//  Created by Simon Lang on 16.05.2024.
//

import SwiftUI

struct TimerStoppedView: View {
    @ObservedObject var meditationManager: MeditationManager
    
    let paddingPickerHorizontal = UIScreen.main.bounds.width / 6
    let halfHeightFrame = UIScreen.main.bounds.height / 8
    
    var body: some View {
        ZStack {
            
            Picker("Time", selection: $meditationManager.meditationTimer.timerInMinutes) {
                ForEach(1...300, id: \.self) { minutes in
                    Text("\(minutes) \(minutes == 1 ? "Minute" : "Minutes")")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .padding(.horizontal, paddingPickerHorizontal)
            
            
            VStack {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                    Button(action: {
                            meditationManager.startMeditation()
                    }, label: {
                        Text("Start")
                            .font(.title2)
                    })
                    .buttonStyle(CircleButtonStyle())
                Spacer()
            }
            
            AdvertisementView()

        }
        
        
    
        

    }
}

#Preview {
    VStack {
        Spacer()
        TimerStoppedView(meditationManager: MeditationManager())
        Spacer()
    }
}
