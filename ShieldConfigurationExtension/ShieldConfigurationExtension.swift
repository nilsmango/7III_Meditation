//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Simon Lang on 11.07.2025.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Override the functions below to customize the shields used in various situations.
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let defaults = UserDefaults(suiteName: "group.com.project7iii.life")
        let hasTopUpTimeAvailable = defaults?.bool(forKey: "topUpActive") ?? false

        let subtitle = hasTopUpTimeAvailable
            ? "This app is currently blocked."
            : "This app is currently blocked, if you need more time, go to 7III Life to unlock more time."

        let secondaryButton = hasTopUpTimeAvailable
            ? ShieldConfiguration.Label(text: "Top up time", color: .systemBlue)
            : nil

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: UIImage(systemName: "shield.fill"),
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: UIColor.systemBlue,
            secondaryButtonLabel: secondaryButton
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        ShieldConfiguration()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        ShieldConfiguration()
    }
}
