//
//  AddActivitySheet.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import SwiftUI

struct AddActivitySheet: View {
    @Binding var newName: String
    @Binding var selectedType: AlternativeActionType
    @Binding var stringValue: String
    @Binding var symbol: String?
    
    @State private var selectedEmoji = ""
    
    @State private var displayEmojiPicker: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Activity name", text: $newName)
            }
            
            Section("Symbol") {
                TextField("Add any Symbol or Letter", text: $selectedEmoji)
                                                            
                }
            .onChange(of: selectedEmoji) {
                if selectedEmoji.count > 1 {
                    selectedEmoji = String(selectedEmoji.prefix(1))
                }
                if selectedEmoji != "" {
                    symbol = selectedEmoji
                } else {
                    symbol = nil
                }
            }
            .onAppear {
                if symbol != nil {
                    selectedEmoji = symbol!
                }
            }
            
            Section(header: Text("")) {
                Picker("Action", selection: $selectedType) {
                    ForEach(AlternativeActionType.allCases) { type in
                        Text(type.beautifulString).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section {
                switch selectedType {
                case .openApp:
                    TextField(detailsHeader, text: $stringValue)
                        .autocapitalization(.none)
                case .openWebsite:
                    TextField(detailsHeader, text: $stringValue)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                case .openInApp:
                    Picker(detailsHeader, selection: $stringValue) {
                        Text("Meditation").tag("meditation")
                    }
                case .closeApp:
                    TextField(detailsHeader, text: $stringValue)
                }
            } header: {
                Text(detailsHeader)
            } footer: {
                if selectedType == .openApp {
                    Text("Ask your local AI for app URL schemes.")
                }
            }
            
        }
    }
        
    private var detailsHeader: String {
        switch selectedType {
        case .openApp: return "App/Universal Link (e.g. ibooks://)"
        case .openWebsite: return "URL (e.g. project7iii.com)"
        case .openInApp: return "7III Life destination"
        case .closeApp: return "Motivational message"
        }
    }
}



#Preview {
    NavigationStack {
        AddActivitySheet(newName: .constant("test"), selectedType: .constant(.closeApp), stringValue: .constant("testinge"), symbol: .constant(nil))
    }
    
}
