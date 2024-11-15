//
//  AppStorageAUValue.swift
//  Meditation
//
//  Created by Simon Lang on 15.11.2024.
//

import Foundation
import SwiftUI
import AudioKit


@propertyWrapper
struct AppStorageAUValue {
    private let key: String
    private let defaultValue: AUValue
    @AppStorage private var storedValue: Double

    init(_ key: String, defaultValue: AUValue) {
        self.key = key
        self.defaultValue = defaultValue
        self._storedValue = AppStorage(wrappedValue: Double(defaultValue), key)
    }

    var wrappedValue: AUValue {
        get { AUValue(storedValue) }
        set { storedValue = Double(newValue) }
    }
}
