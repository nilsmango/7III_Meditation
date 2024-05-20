//
//  Timer.swift
//  Meditation
//
//  Created by Simon Lang on 14.05.2024.
//

import Foundation

/// the meditation timer
struct MeditationTimer: Codable {
    var startDate: Date
    var targetDate: Date
    var timerInMinutes: Int
    var timerStatus: TimerStatus
    /// preparation time in seconds
    var preparationTime: Int
    
    
    var intervalActive: Bool
    /// interval time in seconds
    var intervalTime: Int
    var endSound: TimerSound
    var startSound: TimerSound
    var intervalSound: TimerSound
    
    var timeLeft: String
}

enum TimerStatus: String, CaseIterable, Identifiable, Codable {
    case running, alarm, stopped, paused, preparing
    var id: Self { self }
}

enum TimerSound: String, Codable {
    case kitchenTimer

    var prettyString: String {
        switch self {
        case .kitchenTimer:
            return "Kitchen Timer"
        }
    }

    var rawNotificationSound: String {
        switch self {
        case .kitchenTimer:
            return "Kitchen Timer Normal.caf"
        }
    }
}
