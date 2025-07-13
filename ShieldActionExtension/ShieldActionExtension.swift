//
//  ShieldActionExtension.swift
//  ShieldActionExtension
//
//  Created by Simon Lang on 11.07.2025.
//

import ManagedSettings
import Foundation
import UIKit
import DeviceActivity

// Override the functions below to customize the shield actions used in various situations.
// The system provides a default response for any functions that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldActionExtension: ShieldActionDelegate {
    let deviceActivityCenter = DeviceActivityCenter()
    let store = ManagedSettingsStore()
    
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        case .secondaryButtonPressed:
            let defaults = UserDefaults(suiteName: "group.com.project7iii.life")
            defaults?.set(false, forKey: "topUpActive")
            let topUpMinutes = defaults?.integer(forKey: "topUpMinutes") ?? 1
            
            store.shield.applications?.remove(application)
            
            let event = DeviceActivityEvent(
                applications: [application],
                threshold: DateComponents(minute: topUpMinutes)
            )
            
            let tokenData = try! JSONEncoder().encode(application)
            let base64String = tokenData.base64EncodedString()
            let activityName = DeviceActivityName(base64String)
            let eventNameString = UUID().uuidString
            let eventName = DeviceActivityEvent.Name(eventNameString)
            let schedule = DeviceActivitySchedule(
                intervalStart: DateComponents(hour: 0, minute: 0, second: 0),
                intervalEnd: DateComponents(hour: 23, minute: 59, second: 59),
                repeats: false
            )
                        
            try? deviceActivityCenter.startMonitoring(activityName, during: schedule, events: [eventName : event])
            
            
            
            completionHandler(.none)
            
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        completionHandler(.close)
    }
}

