//
//  BottomGradientModifier.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct BottomGradientOverlay: ViewModifier {
    let color: Color
    let height: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [color, .clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
                .frame(height: height)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea()
                .allowsHitTesting(false)
            )
    }
}

extension View {
    /// Adds a bottom gradient overlay with customizable color and height.
    func bottomGradientOverlay(color: Color = .white, height: CGFloat = 200) -> some View {
        modifier(BottomGradientOverlay(color: color, height: height))
    }
}
