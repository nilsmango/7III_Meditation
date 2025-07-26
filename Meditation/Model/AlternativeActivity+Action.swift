//
//  AlternativeActivity+Action.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import Foundation

struct AlternativeActivity: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var action: AlternativeAction
    var symbol: String?
    
    init(name: String, action: AlternativeAction, symbol: String?) {
        self.id = UUID()
        self.name = name
        self.action = action
        self.symbol = symbol
    }
    
    init(id: UUID, name: String, action: AlternativeAction, symbol: String?) {
        self.id = id
        self.name = name
        self.action = action
        self.symbol = symbol
    }
}

enum AlternativeAction: Codable, Equatable {
    case openApp(appLink: String)
    case openWebsite(URL: String)
    case openInApp(identifier: String)
    case closeApp(message: String)
}

enum AlternativeActionType: String, CaseIterable, Identifiable {
    var id: String { rawValue }

    case openApp, openWebsite, openInApp, closeApp
    
    var beautifulString: String {
        switch self {
        case .openApp:
            return "Open App"
        case .openWebsite:
            return "Open Website"
        case .openInApp:
            return "Open in 7III Life"
        case .closeApp:
            return "Close App"
        }
    }
}
