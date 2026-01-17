//
//  UIBlurEffect+Extensions.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import UIKit

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
