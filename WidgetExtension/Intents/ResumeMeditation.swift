//
//  ResumeMeditation.swift
//  Meditation
//
//  Created by Simon Lang on 31.05.2024.
//

import AppIntents

@available(iOS 16.0, *)
struct ResumeMeditation: AppIntent {
    static var title: LocalizedStringResource = "Resume Meditation"
    static var description = IntentDescription("Resumes the current meditation session.")

    func perform() async throws -> some IntentResult {
        // Call the function from your app model
        DispatchQueue.main.async {
            MeditationManager.shared.startMeditation()
        }
        return .result()
    }
}
