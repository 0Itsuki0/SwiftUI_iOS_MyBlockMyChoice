//
//  UIColor+Extensions.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI

extension UIColor {
    static func rgb(_ rgba: RGBAColor) -> UIColor {
        return UIColor(
            red: CGFloat(rgba.r) / 255.0,
            green: CGFloat(rgba.g) / 255.0,
            blue: CGFloat(rgba.b) / 255.0,
            alpha: rgba.a
        )
    }

    static func rgb(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat)
        -> UIColor
    {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    public convenience init(
        _ red: Int,
        _ green: Int,
        _ blue: Int,
        _ alpha: CGFloat
    ) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha
        )
    }

    var rgba: RGBAColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return RGBAColor(
                r: Int(r * 255.0),
                g: Int(g * 255.0),
                b: Int(b * 255.0),
                a: a
            )
        } else {
            return RGBAColor(r: 0, g: 0, b: 0, a: 0)
        }
    }

}
