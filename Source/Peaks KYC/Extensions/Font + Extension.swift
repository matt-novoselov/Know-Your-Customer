//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//


import SwiftUI

extension Font {
    /// Custom “Dazzed” font from bundle
    /// - Parameters:
    ///   - size: point size
    ///   - weight: font weight (uses UIFont.Weight)
    ///   - width: font width trait (0 = normal, negative = condensed, positive = expanded)
    static func dazzed(
        size: CGFloat,
        weight: UIFont.Weight = .regular,
        width: CGFloat = 0
    ) -> Font {
        let traits: [UIFontDescriptor.TraitKey: Any] = [
            .weight: weight,
            .width: width
        ]
        let descriptor = UIFontDescriptor(fontAttributes: [
            .family: "Dazzed-TRIAL", // your font’s family name
            .traits: traits
        ])
        let uiFont = UIFont(descriptor: descriptor, size: size)
        return Font(uiFont)
    }
}
