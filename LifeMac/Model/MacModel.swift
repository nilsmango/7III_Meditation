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
    
    @AppStorage("isBlocked") var isBlocked = false
    
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
        self.topUpMinutes = UserDefaults(suiteName: appGroupID)?.integer(forKey: "topUpMinutes") ?? 1
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
        isBlocked ? "Blocking Active" : "Blocking Inactive"
    }
    
    var blockingStatusColor: Color {
        isBlocked ? .green : .gray
    }
}
