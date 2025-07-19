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

struct CapsuleButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    private let variant: CapsuleButtonVariant

    init(_ variant: CapsuleButtonVariant = .normal) {
        self.variant = variant
    }
    
    private var backgroundColor: Color {
        return isEnabled ? variant.background : Color(.quaternarySystemFill)
    }
    
    private var foregroundColor: Color {
        return isEnabled ? variant.foreground : Color(.systemGray2)
    }

    func makeBody(configuration: Configuration) -> some View {
        return configuration.label
            .frame(maxWidth: .infinity)
            .font(.body)
            .fontWeight(.semibold)
            .padding(20)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}
