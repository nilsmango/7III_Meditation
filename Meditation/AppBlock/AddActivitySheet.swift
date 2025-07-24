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
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Activity name", text: $newName)
            }
            
            Section(header: Text("Type")) {
                Picker("Action", selection: $selectedType) {
                    ForEach(AlternativeActionType.allCases) { type in
                        Text(type.beautifulString).tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section(header: Text(detailsHeader)) {
                switch selectedType {
                case .openApp:
                    TextField("Bundle ID (e.g. com.apple.books)", text: $stringValue)
                        .autocapitalization(.none)
                case .openWebsite:
                    TextField("URL (e.g. https://example.com)", text: $stringValue)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                case .openInApp:
                    Picker("Destination", selection: $stringValue) {
                        Text("Meditation").tag("meditation")
                    }
                case .closeApp:
                    TextField("Motivational message", text: $stringValue)
                }
            }
        }
    }
    
    private var detailsHeader: String {
        switch selectedType {
        case .openApp: return "Bundle ID (e.g. com.apple.books)"
        case .openWebsite: return "URL (e.g. https://example.com)"
        case .openInApp: return "In-App Destination"
        case .closeApp: return "Motivational Message"
        }
    }
}



#Preview {
    AddActivitySheet(newName: .constant("test"), selectedType: .constant(.closeApp), stringValue: .constant("testinge"))
}
