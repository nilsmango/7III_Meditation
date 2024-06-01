//
//  Reminders.swift
//  Meditation
//
//  Created by Simon Lang on 01.06.2024.
//

import Foundation

struct Reminders: Codable, Equatable {
    var activateReminders: Bool
    var remindAgain: Bool
    var reminderStyle: ReminderStyle
    var reminderTime: Date
}


enum ReminderStyle: String, CaseIterable, Identifiable, Codable, Equatable {
    case automatic, manual
    var id: Self { self }
}
