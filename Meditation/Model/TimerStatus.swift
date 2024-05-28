//
//  TimerStatus.swift
//  Meditation
//
//  Created by Simon Lang on 28.05.2024.
//

import Foundation

enum TimerStatus: String, CaseIterable, Identifiable, Codable {
    case running, alarm, stopped, paused, preparing
    var id: Self { self }
}
