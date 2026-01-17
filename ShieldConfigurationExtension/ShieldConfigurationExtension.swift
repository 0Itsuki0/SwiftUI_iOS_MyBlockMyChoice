//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Itsuki on 2026/01/17.
//

import ManagedSettings
import ManagedSettingsUI
import SwiftUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    private var manager = BlockManager()

    override func configuration(shielding application: Application)
        -> ShieldConfiguration
    {
        return makeConfiguration()
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        return makeConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain)
        -> ShieldConfiguration
    {
        return makeConfiguration()
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        return makeConfiguration()
    }

    private func makeConfiguration() -> ShieldConfiguration {
        let savedConfig = manager.appearanceConfiguration

        let shieldConfiguration = ShieldConfiguration(
            backgroundBlurStyle: savedConfig.backgroundBlurStyle,
            backgroundColor: UIColor(savedConfig.backgroundColor),
            icon: savedConfig.icon,
            title: .init(
                text: savedConfig.title.text,
                color: UIColor(savedConfig.title.color)
            ),
            subtitle: .init(
                text: savedConfig.subtitle.text,
                color: UIColor(savedConfig.subtitle.color)
            ),
            primaryButtonLabel: .init(
                text: savedConfig.primaryButton.label.text,
                color: UIColor(savedConfig.primaryButton.label.color)
            ),
            primaryButtonBackgroundColor: UIColor(
                savedConfig.primaryButtonBackgroundColor
            ),
            secondaryButtonLabel: savedConfig.secondaryButton == nil
                ? nil
                : .init(
                    text: savedConfig.secondaryButton!.label.text,
                    color: UIColor(savedConfig.secondaryButton!.label.color)
                ),
        )

        return shieldConfiguration
    }
}
