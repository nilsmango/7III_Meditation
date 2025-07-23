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
    
    
    init() {
        loadWebsitesSelection()
        loadIsBlocked()
        self.topUpMinutes = UserDefaults(suiteName: appGroupID)?.integer(forKey: "topUpMinutes") ?? 1
    }
    
    // MARK: - App Block
    
    @Published var isBlocked: Bool = false {
        didSet {
            UserDefaults(suiteName: appGroupID)?.set(isBlocked, forKey: "isBlocked")
        }
    }

    func loadIsBlocked() {
        isBlocked = UserDefaults(suiteName: appGroupID)?.bool(forKey: "isBlocked") ?? false
    }
    
    
    // MARK: - Website Selection
    
    func loadWebsitesSelection() {
        websitesSelection = UserDefaults(suiteName: appGroupID)?.stringArray(forKey: "websitesSelection") ?? []
    }
    
    func updateBlockedWebsites() {
        UserDefaults(suiteName: appGroupID)?.set(websitesSelection, forKey: "blockedWebsites")
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
