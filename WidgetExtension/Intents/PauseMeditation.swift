//
//  PauseMeditation.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import AppIntents

@available(iOS 16.0, *)
struct PauseMeditation: AppIntent {
    static var title: LocalizedStringResource = "Pause Meditation"
    static var description = IntentDescription("Pauses the current meditation session.")

    func perform() async throws -> some IntentResult {
        // Call the function from your app model
        DispatchQueue.main.async {
            TheModel.shared.pauseMeditation()
        }
        return .result()
    }
}
