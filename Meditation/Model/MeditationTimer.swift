//
//  Timer.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import Foundation

/// the meditation timer
struct MeditationTimer: Codable {
    var targetDate: Date
    var timerInMinutes: Double
    var running: TimerStatus
}

enum TimerStatus: String, CaseIterable, Identifiable, Codable {
    case running, alarm, stopped, paused, preparing
    var id: Self { self }
}
