//
//  FamilyActivityPickerView.swift
//  Meditation
//
//  Created by Simon Lang on 18.07.2025.
//

import SwiftUI
import FamilyControls

struct FamilyActivityPickerView: View {
    @Binding var selection: FamilyActivitySelection
    @AppStorage("showInfo") var showInfo = true
    
    var body: some View {
        VStack {
            
            FamilyActivityPicker(selection: $selection)
            
            Group {
                if showInfo {
                    Text("Don't select any websites here, use the website selection button instead.")
                }
                
                Button {
                    showInfo.toggle()
                } label: {
                    Label(showInfo ? "Hide Info" : "Show Info", systemImage: "info.circle")
                }
                .buttonStyle(.bordered)
            }
            .padding([.top, .horizontal])
        }
    }
}

#Preview {
    FamilyActivityPickerView(selection: .constant(FamilyActivitySelection()))
        .background(.activityBackground)
}
