//
//  WidgetButtonState.swift
//  Meditation
//
//  Created by Simon Lang on 30.05.2024.
//

import Foundation

enum WidgetButtonState: String {
    case play, stop, pause, resume
    var symbolName: String {
        switch self {
        case .play:
            "play.fill"
        case .stop:
            "xmark"
        case .pause:
            "pause"
        case .resume:
            "arrow.clockwise"
        }
    }
}
