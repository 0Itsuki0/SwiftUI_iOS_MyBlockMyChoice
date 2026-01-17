//
//  ShieldLabelConfiguration.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI

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
