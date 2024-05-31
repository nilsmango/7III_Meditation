//
//  StopMeditationWithoutSaving.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import AppIntents

@available(iOS 16.0, *)
struct StopMeditationWithoutSaving: AppIntent {
    static var title: LocalizedStringResource = "Reset Meditation"
    static var description = IntentDescription("Resets the current meditation session.")

    func perform() async throws -> some IntentResult {
        // Call the function from your app model
        DispatchQueue.main.async {
            MeditationManager.shared.stopMeditation(withSaving: false)
        }
        return .result()
    }
}
