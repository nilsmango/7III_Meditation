//
//  TimerSound.swift
//  Meditation
//
//  Created by Simon Lang on 23.05.2024.
//

import Foundation

struct TimerSound: Codable, Identifiable {
    var id = UUID()
    let name: String
    let fileName: String
}
