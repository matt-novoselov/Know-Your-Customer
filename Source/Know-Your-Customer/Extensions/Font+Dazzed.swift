//
//  File.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

extension Font {
    /// Provides helpers to load the custom "Dazzed" font with different styles.
    /// Custom “Dazzed” font from bundle using text styles
    /// - Parameters:
    ///   - style: UIFont.TextStyle like .body, .title1, etc.
    ///   - weight: font weight (uses UIFont.Weight)
    ///   - width: font width trait (0 = normal, negative = condensed, positive = expanded)
    static func dazzed(
        style: UIFont.TextStyle,
        weight: UIFont.Weight = .regular,
        width: CGFloat = 0
    ) -> Font {
        let traits: [UIFontDescriptor.TraitKey: Any] = [
            .weight: weight,
            .width: width
        ]
        let descriptor = UIFontDescriptor(fontAttributes: [
            .family: "Dazzed-TRIAL",
            .traits: traits
        ])
        let pointSize = UIFont.preferredFont(forTextStyle: style).pointSize
        let uiFont = UIFont(descriptor: descriptor, size: pointSize)
        return Font(uiFont)
    }
}

extension Font {
    /// Custom “Dazzed” font by numeric size
    /// - Parameters:
    ///   - size: exact point size
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
            .family: "Dazzed-TRIAL",
            .traits: traits
        ])
        let uiFont = UIFont(descriptor: descriptor, size: size)
        return Font(uiFont)
    }
}
