//
//  MacModel.swift
//  LifeMac
//
//  Created by Simon Lang on 21.07.2025.
//

import Foundation
import SwiftUI


@MainActor
class MacModel: ObservableObject {
        
    private let appGroupID = "group.com.project7iii.life"
    
    @Published var topUpActive: Bool = false {
        didSet {
            // Automatically sync to UserDefaults whenever the value changes
            UserDefaults(suiteName: appGroupID)?.set(topUpActive, forKey: "topUpActive")
        }
    }
    
    @Published var topUpMinutes: Int = 1 {
        didSet {
            // Automatically sync to UserDefaults whenever the value changes
            UserDefaults(suiteName: appGroupID)?.set(topUpMinutes, forKey: "topUpMinutes")
        }
    }
    
    @Published var websitesSelection : [String] = [] {
        didSet {
            UserDefaults(suiteName: appGroupID)?.set(websitesSelection, forKey: "websitesSelection")
            if isBlocked {
                updateBlockedWebsites()
            }
        }
    }
    
    @Published var alternativesSelection: [AlternativeActivity] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(alternativesSelection) {
                UserDefaults(suiteName: appGroupID)?.set(data, forKey: "alternativesSelection")
            }
        }
    }
    
    func loadAlternatives() {
        if let data = UserDefaults(suiteName: appGroupID)?.data(forKey: "alternativesSelection"),
           let decoded = try? JSONDecoder().decode([AlternativeActivity].self, from: data) {
            alternativesSelection = decoded
        }
    }
    
    func loadUserDefaults() {
        loadWebsitesSelection()
        loadIsBlocked()
        loadOptions()
        loadAlternatives()
        self.topUpMinutes = UserDefaults(suiteName: appGroupID)?.integer(forKey: "topUpMinutes") ?? 1
    }
    
    
    init() {
        loadUserDefaults()
    }
    
    // MARK: - App Block
    
    @Published var isBlocked: Bool = true {
        didSet {
            UserDefaults(suiteName: appGroupID)?.set(isBlocked, forKey: "isBlocked")
        }
    }

    func loadIsBlocked() {
        if UserDefaults(suiteName: appGroupID)?.object(forKey: "isBlocked") == nil {
            isBlocked = true
        } else {
            isBlocked = UserDefaults(suiteName: appGroupID)?.bool(forKey: "isBlocked") ?? true
        }
    }
    
    
    // MARK: - Website Selection
    
    func loadWebsitesSelection() {
        websitesSelection = UserDefaults(suiteName: appGroupID)?.stringArray(forKey: "websitesSelection") ?? []
    }
    
    func updateBlockedWebsites() {
        UserDefaults(suiteName: appGroupID)?.set(websitesSelection, forKey: "blockedWebsites")
    }
    
    // MARK: - Options
    
    @Published var howToButton: Bool = true {
        didSet {
            UserDefaults(suiteName: appGroupID)?.set(howToButton, forKey: "howToButton")
        }
    }
    
    @Published var useAlternativeActivities: Bool = true {
        didSet {
            UserDefaults(suiteName: appGroupID)?.set(useAlternativeActivities, forKey: "useAlternativeActivities")
        }
    }
    
    func loadOptions() {
        howToButton = UserDefaults(suiteName: appGroupID)?.bool(forKey: "howToButton") ?? true
        useAlternativeActivities = UserDefaults(suiteName: appGroupID)?.bool(forKey: "useAlternativeActivities") ?? true
    }
    
    // MARK: - Blocking Management
    func enableBlocking() {
        guard !websitesSelection.isEmpty else { return }
        updateBlockedWebsites()
        isBlocked = true
    }
    
    func disableBlocking() {
        UserDefaults(suiteName: appGroupID)?.set([], forKey: "blockedWebsites")
        isBlocked = false
    }
    
    func toggleBlocking() {
        if isBlocked {
            disableBlocking()
        } else {
            enableBlocking()
        }
    }
    
    // MARK: - Top Up Time
    
    func topUpTime() {
        topUpActive = true
    }
    
    // MARK: - Computed Properties
    
    var hasSelectedWebsites: Bool {
        !websitesSelection.isEmpty
    }
    
    var hasSelectedAlternatives: Bool {
        !alternativesSelection.isEmpty
    }
    
    var selectedWebsitesCount: Int {
        websitesSelection.count
    }
    
    
    var blockingStatusText: String {
        isBlocked ? "Blocking active" : "Blocking inactive"
    }
    
    var blockingStatusColor: Color {
        isBlocked ? .green : .gray
    }
}
