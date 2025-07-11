//
//  AppBlockerModel.swift
//  Meditation
//
//  Created by Simon Lang on 11.07.2025.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity
import SwiftUI

@MainActor
class AppBlockerModel: ObservableObject {
    @Published var selection = FamilyActivitySelection()
    @AppStorage("isBlocked") var isBlocked = false
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    
    private let store = ManagedSettingsStore()
    private let selectionKey = "savedFamilyActivitySelection"
    
    init() {
        checkAuthorizationStatus()
        loadSavedSelection()
    }
    
    // MARK: - Persistence
    private func loadSavedSelection() {
        // The selection is automatically restored from the ManagedSettingsStore
        // when the app launches, so we need to check if there are any existing shields
        if let applications = store.shield.applications, !applications.isEmpty {
            // Create a new selection with the existing tokens
            var newSelection = FamilyActivitySelection()
            newSelection.applicationTokens = applications
            
            if let categories = store.shield.applicationCategories {
                switch categories {
                case .specific(let categoryTokens, except: _):
                    newSelection.categoryTokens = categoryTokens
                default:
                    break
                }
            }
            
            self.selection = newSelection
        }
    }
    
    // MARK: - Authorization
    func checkAuthorizationStatus() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                authorizationStatus = AuthorizationCenter.shared.authorizationStatus
            } catch {
                print("Authorization check failed: \(error)")
                authorizationStatus = AuthorizationCenter.shared.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            authorizationStatus = AuthorizationCenter.shared.authorizationStatus
        } catch {
            print("Authorization failed: \(error)")
        }
    }
    
    // MARK: - Blocking Management
    func enableBlocking() {
        guard !selection.applicationTokens.isEmpty else { return }
        
        store.shield.applications = selection.applicationTokens
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
        isBlocked = true
    }
    
    func disableBlocking() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        isBlocked = false
    }
    
    func toggleBlocking() {
        if isBlocked {
            disableBlocking()
        } else {
            enableBlocking()
        }
    }
    
    // MARK: - Computed Properties
    var hasSelectedApps: Bool {
        !selection.applicationTokens.isEmpty
    }
    
    var selectedAppsCount: Int {
        selection.applicationTokens.count
    }
    
    var isAuthorized: Bool {
        authorizationStatus == .approved
    }
    
    var blockingStatusText: String {
        isBlocked ? "Blocking Active" : "Blocking Inactive"
    }
    
    var blockingStatusColor: Color {
        isBlocked ? .green : .gray
    }
}
