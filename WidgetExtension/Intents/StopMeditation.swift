//
//  StopMeditation.swift
//  Meditation
//
//  Created by Simon Lang on 29.05.2024.
//

import AppIntents

@available(iOS 16.0, *)
struct StopMeditation: AppIntent {
    static var title: LocalizedStringResource = "Stop Meditation"
    static var description = IntentDescription("Stops the current meditation session.")

    func perform() async throws -> some IntentResult {
        // Call the function from your app model
        DispatchQueue.main.async {
            MeditationManager.shared.stopMeditation()
        }
        return .result()
    }
}
