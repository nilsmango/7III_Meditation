//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Simon Lang on 12.07.2025.
//

import DeviceActivity
import Foundation
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        // Handle the event reaching its threshold.
        if event.rawValue.hasPrefix("webDomain") {
            // adding the application back to the shield
            let base64String = activity.rawValue
            if let data = Data(base64Encoded: base64String),
               let token = try? JSONDecoder().decode(WebDomainToken.self, from: data) {
                let store = ManagedSettingsStore()
                store.shield.webDomains?.insert(token)
                
            }
        } else {
            // adding the application back to the shield
            let base64String = activity.rawValue
            if let data = Data(base64Encoded: base64String),
               let token = try? JSONDecoder().decode(ApplicationToken.self, from: data) {
                let store = ManagedSettingsStore()
                store.shield.applications?.insert(token)
                
            }
        }
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
    
}
