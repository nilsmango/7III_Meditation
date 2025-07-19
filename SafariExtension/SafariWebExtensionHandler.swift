//
//  SafariWebExtensionHandler.swift
//  SafariExtension
//
//  Created by Simon Lang on 19.07.2025.
//

import SafariServices
import Foundation
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    // App Group identifier
    private let appGroupIdentifier = "group.com.project7iii.life"
    
    // Storage keys (should match your main app)
    private struct StorageKeys {
        static let blockedWebsites = "blockedWebsites"
        static let unshieldEndTime = "unshieldEndTime"
        static let lastTopUpRequest = "lastTopUpRequest"
    }
    
    private var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupIdentifier)
    }
    
    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey] as? [String: Any]
        
        os_log(.default, "Safari Extension received message: %{public}@", String(describing: message))
        
        guard let message = message,
              let messageType = message["type"] as? String else {
            context.completeRequest(returningItems: [], completionHandler: nil)
            return
        }
        
        var response: [String: Any] = [:]
        
        switch messageType {
        case "getData":
            response = handleGetData()
            
        case "requestTopUp":
            let domain = message["domain"] as? String ?? ""
            response = handleTopUpRequest(domain: domain)
            
        case "timerExpired":
            response = handleTimerExpired()
            
        default:
            response = ["success": false, "error": "Unknown message type"]
        }
        
        let responseItem = NSExtensionItem()
        responseItem.userInfo = [SFExtensionMessageKey: response]
        
        context.completeRequest(returningItems: [responseItem], completionHandler: nil)
    }
    
    // MARK: - Message Handlers
    
    private func handleGetData() -> [String: Any] {
        guard let defaults = sharedDefaults else {
            return ["success": false, "error": "Could not access shared defaults"]
        }
        
        let blockedWebsites = defaults.stringArray(forKey: StorageKeys.blockedWebsites) ?? []
        let unshieldEndTime = defaults.object(forKey: StorageKeys.unshieldEndTime) as? Double
        
        var response: [String: Any] = [
            "success": true,
            "blockedDomains": extractDomainsFromWebsites(blockedWebsites)
        ]
        
        if let endTime = unshieldEndTime, endTime > Date().timeIntervalSince1970 * 1000 {
            response["unshieldEndTime"] = endTime
        }
        
        return response
    }
    
    private func handleTopUpRequest(domain: String) -> [String: Any] {
        guard let defaults = sharedDefaults else {
            return ["success": false, "error": "Could not access shared defaults"]
        }
        
        // Store the top-up request for the main app to handle
        let topUpRequest = [
            "domain": domain,
            "timestamp": Date().timeIntervalSince1970 * 1000,
            "processed": false
        ] as [String: Any]
        
        if let data = try? JSONSerialization.data(withJSONObject: topUpRequest) {
            defaults.set(data, forKey: StorageKeys.lastTopUpRequest)
            
            // Send notification to main app if possible
            NotificationCenter.default.post(
                name: NSNotification.Name("LifeShieldTopUpRequested"),
                object: nil,
                userInfo: ["domain": domain]
            )
            
            return ["success": true, "message": "Top-up request submitted"]
        }
        
        return ["success": false, "error": "Failed to store top-up request"]
    }
    
    private func handleTimerExpired() -> [String: Any] {
        // Notify main app that timer expired
        NotificationCenter.default.post(
            name: NSNotification.Name("LifeShieldTimerExpired"),
            object: nil
        )
        
        return ["success": true]
    }
    
    // MARK: - Helper Methods
    
    private func extractDomainsFromWebsites(_ websites: [String]) -> [String] {
        return websites.compactMap { website in
            // If it's already a domain, return as is
            if !website.contains("/") {
                return website
            }
            
            // If it's a URL, extract the domain
            if let url = URL(string: website.hasPrefix("http") ? website : "https://\(website)") {
                return url.host?.replacingOccurrences(of: "www.", with: "")
            }
            
            // Fallback: try to extract domain from string
            let components = website.replacingOccurrences(of: "https://", with: "")
                                   .replacingOccurrences(of: "http://", with: "")
                                   .components(separatedBy: "/")
            
            return components.first?.replacingOccurrences(of: "www.", with: "")
        }
    }
}

// MARK: - Notification Extensions

extension NSNotification.Name {
    static let lifeShieldTopUpRequested = NSNotification.Name("LifeShieldTopUpRequested")
    static let lifeShieldTimerExpired = NSNotification.Name("LifeShieldTimerExpired")
}

// MARK: - Data Models

struct LifeShieldExtensionData {
    let blockedDomains: [String]
    let unshieldEndTime: Double?
    
    init(from defaults: UserDefaults, appGroupKey: String) {
        self.blockedDomains = []
        self.unshieldEndTime = nil
        
        // You might want to implement data loading logic here
        // based on how your main app stores the data
    }
}
