//
//  BottomGradientModifier.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

/// Overlays a fading gradient at the specified edge of a view.
struct GradientOverlayModifier: ViewModifier {
    let color: Color
    let height: CGFloat
    let edge: Edge

    init(color: Color = .white, height: CGFloat = 200, edge: Edge = .bottom) {
        self.color = color
        self.height = height
        self.edge = edge
    }

    func body(content: Content) -> some View {
        let startPoint: UnitPoint = edge == .bottom ? .bottom : .top
        let endPoint: UnitPoint = edge == .bottom ? .top : .bottom
        let alignment: Alignment = edge == .bottom ? .bottom : .top

        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [color, .clear]),
                    startPoint: startPoint,
                    endPoint: endPoint
                )
                .frame(height: height)
                .frame(maxHeight: .infinity, alignment: alignment)
                .ignoresSafeArea(edges: .init(edge))
                .allowsHitTesting(false)
            )
    }
}

extension View {
    func gradientOverlay(
        color: Color = .white,
        height: CGFloat = 200,
        edge: Edge = .bottom
    ) -> some View {
        modifier(GradientOverlayModifier(color: color, height: height, edge: edge))
    }
}
