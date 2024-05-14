//
//  CompletedMeditation.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import Foundation

struct MeditationSession: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
}
