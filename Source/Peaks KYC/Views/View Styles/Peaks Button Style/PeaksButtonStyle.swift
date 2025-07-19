//
//  PeaksButtonStyle.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct PeaksButtonStyle: ButtonStyle {
    private let variant: ButtonVariant
    @Environment(\.isEnabled) private var isEnabled
    
    init(_ variant: ButtonVariant = .normal) {
        self.variant = variant
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let bg = isEnabled ? variant.background : .gray.mix(with: .white, by: 0.9)
        let fg = isEnabled ? variant.foreground : .gray.mix(with: .white, by: 0.4)
        
        return configuration.label
            .frame(maxWidth: .infinity)
            .font(.body)
            .fontWeight(.semibold)
            .padding(20)
            .background(bg)
            .foregroundColor(fg)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}
