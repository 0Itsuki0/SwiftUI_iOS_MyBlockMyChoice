//
//  ShieldButtonConfiguration.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import ManagedSettings

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
