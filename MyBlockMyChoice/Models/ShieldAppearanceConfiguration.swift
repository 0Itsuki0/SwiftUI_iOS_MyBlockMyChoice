//
//  ShieldAppearanceConfiguration.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//


import SwiftUI
import ManagedSettings

struct ShieldAppearanceConfiguration: Codable, Equatable {

    var backgroundBlurStyle: UIBlurEffect.Style? {
        get {
            guard let backgroundBlurStyleRawValue else { return nil }
            return UIBlurEffect.Style(rawValue: backgroundBlurStyleRawValue)
        }
        set {
            backgroundBlurStyleRawValue = newValue?.rawValue
        }
    }
    
    var backgroundBlurStyleRawValue: Int?

    var backgroundColor: Color {
        get {
            return Color(uiColor: UIColor.rgb(backgroundRGBA))
        }
        set {
            let uiColor = UIColor(newValue)
            backgroundRGBA = uiColor.rgba
        }
    }

    var backgroundRGBA: RGBAColor

    var icon: UIImage? {
        get {
            guard let iconData else {
                return nil
            }
            return UIImage(data: iconData)
        }
        set {
            self.iconData = newValue?.pngData()
        }
    }

    var iconData: Data?

    var title: ShieldLabelConfiguration
    var subtitle: ShieldLabelConfiguration
    var primaryButton: ShieldButtonConfiguration

    var primaryButtonBackgroundColor: Color {
        get {
            return Color(uiColor: UIColor.rgb(primaryButtonBackgroundColorRGBA))
        }
        set {
            let uiColor = UIColor(newValue)
            primaryButtonBackgroundColorRGBA = uiColor.rgba
        }
    }

    var primaryButtonBackgroundColorRGBA: RGBAColor

    var secondaryButton: ShieldButtonConfiguration?
}

extension ShieldAppearanceConfiguration {


    static let defaultConfiguration = ShieldAppearanceConfiguration(
        backgroundBlurStyleRawValue: nil,
        backgroundRGBA: UIColor.secondarySystemBackground.rgba,
        iconData: UIImage(systemName: "hourglass.tophalf.filled")?.withTintColor(.blue)
            .pngData(),
        title: .init(text: "Restricted", rgba: UIColor.label.rgba),
        subtitle: .init(
            text:
                "You cannot use \(ShieldLabelConfiguration.appNamePlaceholder) because it is restricted",
            rgba: UIColor.secondaryLabel.rgba
        ),
        primaryButton: .init(
            label: .init(text: "OK", rgba: UIColor.white.rgba),
            actionRawValue: ShieldActionResponse.close.rawValue
        ),
        primaryButtonBackgroundColorRGBA: UIColor.systemBlue.rgba,
        secondaryButton: nil
    )
}
