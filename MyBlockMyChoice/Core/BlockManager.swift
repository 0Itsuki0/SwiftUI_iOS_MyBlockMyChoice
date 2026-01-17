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
