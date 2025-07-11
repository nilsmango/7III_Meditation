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
import SwiftUICore

@MainActor
class AppBlockerModel: ObservableObject {
    @Published var selection = FamilyActivitySelection()
    @Published var isBlocked = false
    @Published var authorizationStatus: AuthorizationStatus = .notDetermined
    
    private let store = ManagedSettingsStore()
    
    // MARK: - Authorization
    func checkAuthorizationStatus() {
            Task {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                authorizationStatus = AuthorizationCenter.shared.authorizationStatus
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

