//
//  DateComponents + Identifiable.swift
//  Meditation
//
//  Created by Simon Lang on 27.05.2024.
//

import Foundation

extension DateComponents: Identifiable {
    public var id: String {
        var components = [String]()
        
        if let year = year {
            components.append("Y\(year)")
        }
        if let month = month {
            components.append("M\(month)")
        }
        if let day = day {
            components.append("D\(day)")
        }
        if let hour = hour {
            components.append("H\(hour)")
        }
        if let minute = minute {
            components.append("Min\(minute)")
        }
        if let second = second {
            components.append("S\(second)")
        }
        
        return components.joined(separator: "-")
    }
}
