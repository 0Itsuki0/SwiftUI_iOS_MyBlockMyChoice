//
//  ShieldActionResponse+Extensions.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import ManagedSettings

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
