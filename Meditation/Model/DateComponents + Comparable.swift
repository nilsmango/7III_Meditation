//
//  DateComponents + Comparable.swift
//  Meditation
//
//  Created by Simon Lang on 27.05.2024.
//

import Foundation

extension DateComponents: @retroactive Comparable {
    public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
        // Compare each component in the following order: year, month, day, hour, minute, second
        if let lhsYear = lhs.year, let rhsYear = rhs.year {
            if lhsYear != rhsYear {
                return lhsYear < rhsYear
            }
        }
        if let lhsMonth = lhs.month, let rhsMonth = rhs.month {
            if lhsMonth != rhsMonth {
                return lhsMonth < rhsMonth
            }
        }
        if let lhsDay = lhs.day, let rhsDay = rhs.day {
            if lhsDay != rhsDay {
                return lhsDay < rhsDay
            }
        }
        if let lhsHour = lhs.hour, let rhsHour = rhs.hour {
            if lhsHour != rhsHour {
                return lhsHour < rhsHour
            }
        }
        if let lhsMinute = lhs.minute, let rhsMinute = rhs.minute {
            if lhsMinute != rhsMinute {
                return lhsMinute < rhsMinute
            }
        }
        if let lhsSecond = lhs.second, let rhsSecond = rhs.second {
            return lhsSecond < rhsSecond
        }
        
        // If all components are equal, return false
        return false
    }
    
    public static func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
        return lhs.year == rhs.year &&
            lhs.month == rhs.month &&
            lhs.day == rhs.day &&
            lhs.hour == rhs.hour &&
            lhs.minute == rhs.minute &&
            lhs.second == rhs.second
    }
}
