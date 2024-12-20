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
    var secondReminder: Bool
    var intervalSound: TimerSound
    var reminderSound: TimerSound
    
    var showKoan: Bool
    var koans: [String]
    
    var statistics: MeditationStatistics
}


