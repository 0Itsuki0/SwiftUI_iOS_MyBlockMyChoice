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
        return makeConfiguration(
            application.localizedDisplayName ?? "(unknown app)"
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        return makeConfiguration(
            application.localizedDisplayName ?? "(unknown app)"
        )
    }

    override func configuration(shielding webDomain: WebDomain)
        -> ShieldConfiguration
    {
        return makeConfiguration(webDomain.domain ?? "(unknown web domain)")
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        return makeConfiguration(webDomain.domain ?? "(unknown web domain)")
    }

    private func makeConfiguration(_ appName: String) -> ShieldConfiguration {
        let savedConfig = manager.appearanceConfiguration

        let shieldConfiguration = ShieldConfiguration(
            backgroundBlurStyle: savedConfig.backgroundBlurStyle,
            backgroundColor: UIColor(savedConfig.backgroundColor),
            icon: savedConfig.icon,
            title: .init(
                text: savedConfig.title.text.replacingOccurrences(
                    of: ShieldLabelConfiguration.appNamePlaceholder,
                    with: appName
                ),
                color: UIColor(savedConfig.title.color)
            ),
            subtitle: .init(
                text: savedConfig.subtitle.text.replacingOccurrences(
                    of: ShieldLabelConfiguration.appNamePlaceholder,
                    with: appName
                ),
                color: UIColor(savedConfig.subtitle.color)
            ),
            primaryButtonLabel: .init(
                text: savedConfig.primaryButton.label.text.replacingOccurrences(
                    of: ShieldLabelConfiguration.appNamePlaceholder,
                    with: appName
                ),
                color: UIColor(savedConfig.primaryButton.label.color)
            ),
            primaryButtonBackgroundColor: UIColor(
                savedConfig.primaryButtonBackgroundColor
            ),
            secondaryButtonLabel: savedConfig.secondaryButton == nil
                ? nil
                : .init(
                    text: savedConfig.secondaryButton!.label.text
                        .replacingOccurrences(
                            of: ShieldLabelConfiguration.appNamePlaceholder,
                            with: appName
                        ),
                    color: UIColor(savedConfig.secondaryButton!.label.color)
                ),
        )

        return shieldConfiguration
    }
}
