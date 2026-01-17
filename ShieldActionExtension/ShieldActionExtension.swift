//
//  ShieldActionExtension.swift
//  ShieldActionExtension
//
//  Created by Itsuki on 2026/01/17.
//

import ManagedSettings

class ShieldActionExtension: ShieldActionDelegate {
    private var manager = BlockManager()

    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        handleAction(action: action, completionHandler: completionHandler)
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        handleAction(action: action, completionHandler: completionHandler)
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle the action as needed.
        handleAction(action: action, completionHandler: completionHandler)
    }
    
    private func handleAction(action: ShieldAction, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        let configuration = manager.appearanceConfiguration
        
        switch action {
        case .primaryButtonPressed:
            let primaryButton = configuration.primaryButton
            if primaryButton.action == .none {
                manager.removeRestrictions()
            }
            completionHandler(primaryButton.action)
        case .secondaryButtonPressed:
            guard let secondaryButton = configuration.secondaryButton else {
                completionHandler(.none)
                return
            }
            if secondaryButton.action == .none {
                manager.removeRestrictions()
            }
            completionHandler(secondaryButton.action)

        @unknown default:
            fatalError()
        }

    }
}
