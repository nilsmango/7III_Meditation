//
//  SafariWebExtensionHandler.swift
//  MacSafariExtension
//
//  Created by Simon Lang on 23.07.2025.
//

import SafariServices
import os.log

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {

    func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let message: Any?
        if #available(iOS 15.0, macOS 11.0, *) {
            message = request?.userInfo?[SFExtensionMessageKey]
        } else {
            message = request?.userInfo?["message"]
        }

        // Handle the message
        var responseMessage: [String: Any] = [:]
        
        if let messageDict = message as? [String: Any] {
            if let action = messageDict["action"] as? String {
                if action == "getBlockedWebsites" {
                    // Read blocked websites from app group
                    if let sharedDefaults = UserDefaults(suiteName: "group.com.project7iii.life") {
                        let blockedWebsites = sharedDefaults.array(forKey: "blockedWebsites") as? [String] ?? []
                        let topUpActive = sharedDefaults.bool(forKey: "topUpActive")
                        let topUpMinutes = sharedDefaults.integer(forKey: "topUpMinutes")
                        
                        responseMessage = [
                            "websites": blockedWebsites,
                            "topUpActive": topUpActive,
                            "topUpMinutes": topUpMinutes
                        ]
                        
                    } else {
                        responseMessage = ["error": "Could not access app group"]
                    }
                } else if action == "remove-top-up" {
                    UserDefaults(suiteName: "group.com.project7iii.life")?.set(false, forKey: "topUpActive")
                } else {
                    responseMessage = ["echo": message ?? []]
                }
            } else {
                responseMessage = ["echo": message ?? []]
            }
        }

        let response = NSExtensionItem()
        if #available(iOS 15.0, macOS 11.0, *) {
            response.userInfo = [SFExtensionMessageKey: responseMessage]
        } else {
            response.userInfo = ["message": responseMessage]
        }

        context.completeRequest(returningItems: [response], completionHandler: nil)
    }
}

