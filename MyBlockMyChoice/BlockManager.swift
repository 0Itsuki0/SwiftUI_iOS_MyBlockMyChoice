//
//  DeviceActivityManager.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import PhotosUI
import SwiftUI

struct TransferableImage: Transferable {
    let uiImage: UIImage

    enum TransferError: Error {
        case importFailed
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            return TransferableImage(uiImage: uiImage)
        }
    }
}

struct RGBAColor: Codable, Equatable {
    var r: Int
    var g: Int
    var b: Int
    var a: CGFloat
}

struct ShieldLabelConfiguration: Codable, Equatable {
    var text: String
    var color: Color {
        get {
            return Color(uiColor: UIColor.rgb(rgba))
        }
        set {
            let uiColor = UIColor(newValue)
            rgba = uiColor.rgba
        }
    }

    var rgba: RGBAColor
    
    static let appNamePlaceholder = "{AppName}"

}

struct ShieldButtonConfiguration: Codable, Equatable {
    var label: ShieldLabelConfiguration
    var actionRawValue: Int
    var action: ShieldActionResponse {
        get {
            return ShieldActionResponse(rawValue: actionRawValue) ?? .close
        }
        set {
            self.actionRawValue = newValue.rawValue
        }
    }
}

extension UIBlurEffect.Style? {
    var title: String {
        switch self {
        case .none:
            "No Blur"
        case .extraLight:
            "Extra Light"
        case .light:
            "Light"
        case .dark:
            "Dark"
        case .regular:
            "Regular"
        case .prominent:
            "prominent"
        default:
            ""
        }
    }
}

extension UIBlurEffect.Style {
    static let choiceAvailable: [UIBlurEffect.Style?] = [
        .none, .extraLight, .light, .dark, .regular, .prominent,
    ]
}


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

    //    var primaryButtonBackgroundColor: UIColor {
    //        return UIColor.rgb(primaryButtonBackgroundColorRGBA)
    //    }
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

extension ShieldActionResponse {
    var descriptionTitle: String {
        switch self {
        case .none:
            "Remove Restriction"
        case .close:
            "Close App"
        case .defer:
            ""
        @unknown default:
            ""
        }
    }

    var descriptionSubtitle: String {
        switch self {
        case .none:
            "Remove the restrictions immediately and start using the app."
        case .close:
            "Close the current app or browser."
        case .defer:
            ""
        @unknown default:
            ""
        }
    }

    static let choiceAvailable: [ShieldActionResponse] = [.none, .close]
}

@Observable
class BlockManager {

    private(set) var shieldApplied: Bool = false

    var shouldPromptUpdateShield: Bool {
        return
            !(activitySelection.applicationTokens
            == managedSettingsStore.shield.applications
            && activitySelection.categoryTokens
                == managedSettingsStore.shield.categories
            && activitySelection.webDomainTokens
                == managedSettingsStore.shield.webDomains)
    }

    var activitySelection: FamilyActivitySelection = FamilyActivitySelection() {
        didSet {
            self.saveSelection(activitySelection)
        }
    }

    var appearanceConfiguration: ShieldAppearanceConfiguration =
        ShieldAppearanceConfiguration.defaultConfiguration
    {
        didSet {
            self.saveAppearanceConfiguration(appearanceConfiguration)
        }
    }

    private static let nameIdentifier = "itsuki.enjoy.MyBlockMyChoice"
    // A data store that stores settings to the current user or device.
    private let managedSettingsStore: ManagedSettingsStore =
        ManagedSettingsStore(named: .init(nameIdentifier))

    private let userDefaults: UserDefaults =
        UserDefaults(suiteName: "group.itsuki.enjoy.MyBlockMyChoice")
        ?? .standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()

    private let activitySelectionKey = "activitySelection"
    private let configurationKey = "configuration"

    init() {
        self.activitySelection = getSavedSelection()
        self.appearanceConfiguration = getSavedAppearanceConfiguration()
    }

    func applyRestrictions() {
        self.applyImmediateRestrictions(
            applicationTokens: activitySelection.applicationTokens,
            categoryTokens: activitySelection.categoryTokens,
            webDomainTokens: activitySelection.webDomainTokens
        )
    }

    func applyImmediateRestrictions(
        applicationTokens: Set<ApplicationToken>,
        categoryTokens: Set<ActivityCategoryToken>,
        webDomainTokens: Set<WebDomainToken>
    ) {
        managedSettingsStore.shield.applications = applicationTokens
        managedSettingsStore.shield.categories = categoryTokens
        managedSettingsStore.shield.webDomains = webDomainTokens
        self.updateShieldApplied()
    }

    func removeRestrictions() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.categories = nil
        managedSettingsStore.shield.webDomains = nil
        self.updateShieldApplied()
    }

    func removeRestriction(for application: ApplicationToken) {
        managedSettingsStore.shield.applications?.remove(application)
        self.updateShieldApplied()
    }

    func removeRestriction(for webDomain: WebDomainToken) {
        managedSettingsStore.shield.webDomains?.remove(webDomain)
        self.updateShieldApplied()
    }

    func removeRestriction(for category: ActivityCategoryToken) {
        managedSettingsStore.shield.categories?.remove(category)
        self.updateShieldApplied()
    }

    private func updateShieldApplied() {
        self.shieldApplied =
            !((managedSettingsStore.shield.applications == nil
            || managedSettingsStore.shield.applications?.isEmpty == true)
            && (managedSettingsStore.shield.categories == nil
                || managedSettingsStore.shield.categories?.isEmpty == true)
            && (managedSettingsStore.shield.webDomains == nil
                || managedSettingsStore.shield.webDomains?.isEmpty == true))
    }
}

extension ShieldSettings {
    var categories: Set<ActivityCategoryToken>? {
        get {
            guard let applicationCategories = self.applicationCategories else {
                return nil
            }
            guard case .specific(let categoryTokens, _) = applicationCategories
            else {
                return nil
            }
            return categoryTokens
        }
        set {
            if let newValue {
                self.applicationCategories = .specific(newValue, except: [])
            } else {
                self.applicationCategories = nil
            }
        }
    }
}

// MARK: Permission
extension BlockManager {
    static func requestFamilyControlAuthorization() async {
        let center = AuthorizationCenter.shared
        if center.authorizationStatus == .notDetermined {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch (let error) {
                print(error)
            }
        }
    }
}

// MARK: UserDefaults
extension BlockManager {
    private func getSavedSelection() -> FamilyActivitySelection {
        guard let data = userDefaults.data(forKey: self.activitySelectionKey),
            let selection = try? self.jsonDecoder.decode(
                FamilyActivitySelection.self,
                from: data
            )
        else {
            return FamilyActivitySelection()
        }
        return selection
    }

    private func saveSelection(_ selection: FamilyActivitySelection) {
        if let data = try? self.jsonEncoder.encode(selection) {
            userDefaults.set(data, forKey: self.activitySelectionKey)
        }
    }

    private func getSavedAppearanceConfiguration()
        -> ShieldAppearanceConfiguration
    {
        guard let data = userDefaults.data(forKey: self.configurationKey),
            let configuration = try? self.jsonDecoder.decode(
                ShieldAppearanceConfiguration.self,
                from: data
            )
        else {
            return ShieldAppearanceConfiguration.defaultConfiguration
        }
        return configuration
    }

    private func saveAppearanceConfiguration(
        _ configuration: ShieldAppearanceConfiguration
    ) {
        if let data = try? self.jsonEncoder.encode(configuration) {
            userDefaults.set(data, forKey: self.configurationKey)
        }
    }

}
