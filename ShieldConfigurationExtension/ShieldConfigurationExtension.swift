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

        let outerConfig = UIImage.SymbolConfiguration(pointSize: 61, weight: .regular)
        let middleConfig = UIImage.SymbolConfiguration(pointSize: 59, weight: .regular)
        let innerConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .regular)

        let outerCircle = UIImage(systemName: "circle", withConfiguration: outerConfig)!.withTintColor(.white)
        let middleCircle = UIImage(systemName: "circle", withConfiguration: middleConfig)!.withTintColor(.white)
        let innerCircle = UIImage(systemName: "circle", withConfiguration: innerConfig)!.withTintColor(.black)

        let size = outerCircle.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        let center = CGPoint(x: size.width / 2, y: size.height / 2)

        func drawCentered(_ image: UIImage, pointSize: CGFloat) {
            let drawSize = image.size
            let origin = CGPoint(
                x: center.x - drawSize.width / 2,
                y: center.y - drawSize.height / 2
            )
            image.draw(at: origin)
        }

        // Draw all centered
        drawCentered(outerCircle, pointSize: 61)
        drawCentered(middleCircle, pointSize: 59)
        drawCentered(innerCircle, pointSize: 60)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()


        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterial,
            backgroundColor: UIColor.systemBackground,
            icon: finalImage,
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
            icon: UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular))!.withTintColor(UIColor { _ in UIColor.label }),
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
            icon: UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular))!.withTintColor(UIColor { _ in UIColor.label }),
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
            icon: UIImage(systemName: "circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 60, weight: .regular))!.withTintColor(UIColor { _ in UIColor.label }),
            title: ShieldConfiguration.Label(text: "Blocked by 7III Life", color: .label),
            subtitle: ShieldConfiguration.Label(text: subtitle, color: .secondaryLabel),
            primaryButtonLabel: ShieldConfiguration.Label(text: "OK", color: .white),
            primaryButtonBackgroundColor: .greenAccent,
            secondaryButtonLabel: secondaryButton
        )
    }
}
