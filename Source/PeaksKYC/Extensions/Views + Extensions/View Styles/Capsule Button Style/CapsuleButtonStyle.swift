//
//  PeaksButtonStyle.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

extension ButtonStyle where Self == CapsuleButtonStyle {
    static var capsule: Self { .init() }
    static func capsule(_ variant: CapsuleButtonVariant) -> Self { .init(variant) }
}

// Styles buttons as pill-shaped controls with variants.
struct CapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    private let variant: CapsuleButtonVariant

    init(_ variant: CapsuleButtonVariant = .normal) {
        self.variant = variant
    }

    func makeBody(configuration: Configuration) -> some View {
        let bgColor = isEnabled ? variant.background : Color(.quaternarySystemFill)
        let fgColor = isEnabled ? variant.foreground : Color(.systemGray2)

        return configuration.label
            .frame(maxWidth: .infinity)
            .font(.body)
            .fontWeight(.semibold)
            .padding(20)
            .background(bgColor)
            .foregroundColor(fgColor)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}
