//
//  AlternativeActivity+Action.swift
//  Meditation
//
//  Created by Simon Lang on 24.07.2025.
//

import Foundation

struct AlternativeActivity: Codable {
    var name: String
    var action: AlternativeAction
}

enum AlternativeAction: Codable {
    case openApp(bundleID: String)
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
