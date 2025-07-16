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
    let icon = UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular))!.withTintColor(.label)
    
    private func getFreshDefaults() -> UserDefaults? {
        // Create a new instance each time to ensure fresh data
        return UserDefaults(suiteName: "group.com.project7iii.life")
    }
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        let defaults = getFreshDefaults()
        let hasTopUpTimeAvailable = defaults?.bool(forKey: "topUpActive") ?? false
        let topUpMinutes = defaults?.integer(forKey: "topUpMinutes") ?? 1

        let subtitle = hasTopUpTimeAvailable
            ? "This app is currently blocked."
            : "This app is currently blocked, if you need more time, go to 7III Life to unlock more time."

        let secondaryButton = hasTopUpTimeAvailable
            ? ShieldConfiguration.Label(text: "Unlock for \(topUpMinutes) min", color: .label)
            : nil

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: icon,
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .greenAccent,
            secondaryButtonLabel: secondaryButton
        )
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        let defaults = getFreshDefaults()
        let hasTopUpTimeAvailable = defaults?.bool(forKey: "topUpActive") ?? false
        let topUpMinutes = defaults?.integer(forKey: "topUpMinutes") ?? 1

        let subtitle = hasTopUpTimeAvailable
            ? "This app is currently blocked."
            : "This app is currently blocked, if you need more time, go to 7III Life to unlock more time."

        let secondaryButton = hasTopUpTimeAvailable
            ? ShieldConfiguration.Label(text: "Unlock for \(topUpMinutes) min", color: .label)
            : nil

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: icon,
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .greenAccent,
            secondaryButtonLabel: secondaryButton
        )
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        let defaults = getFreshDefaults()
        let hasTopUpTimeAvailable = defaults?.bool(forKey: "topUpActive") ?? false
        let topUpMinutes = defaults?.integer(forKey: "topUpMinutes") ?? 1

        let subtitle = hasTopUpTimeAvailable
            ? "This website is currently blocked."
            : "This website is currently blocked, if you need more time, go to 7III Life to unlock more time."

        let secondaryButton = hasTopUpTimeAvailable
            ? ShieldConfiguration.Label(text: "Unlock for \(topUpMinutes) min", color: .label)
            : nil

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: icon,
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .greenAccent,
            secondaryButtonLabel: secondaryButton
        )
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        let defaults = getFreshDefaults()
        let hasTopUpTimeAvailable = defaults?.bool(forKey: "topUpActive") ?? false
        let topUpMinutes = defaults?.integer(forKey: "topUpMinutes") ?? 1

        let subtitle = hasTopUpTimeAvailable
            ? "This website is currently blocked."
            : "This website is currently blocked, if you need more time, go to 7III Life to unlock more time."

        let secondaryButton = hasTopUpTimeAvailable
            ? ShieldConfiguration.Label(text: "Unlock for \(topUpMinutes) min", color: .label)
            : nil

        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: icon,
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .greenAccent,
            secondaryButtonLabel: secondaryButton
        )
    }
}
