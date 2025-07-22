//
//  BottomGradientModifier.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct GradientOverlay: ViewModifier {
    let color: Color
    let height: CGFloat
    let edge: Edge  // .bottom or .top

    init(color: Color = .white, height: CGFloat = 200, edge: Edge = .bottom) {
        self.color = color
        self.height = height
        self.edge = edge
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [color, .clear]),
                    startPoint: edge == .bottom ? .bottom : .top,
                    endPoint: edge == .bottom ? .top    : .bottom
                )
                .frame(height: height)
                .frame(maxHeight: .infinity,
                       alignment: edge == .bottom ? .bottom : .top)
                .ignoresSafeArea(edges: .init(edge))
                .allowsHitTesting(false)
            )
    }
}

extension View {
    /// Adds a top or bottom gradient overlay (bottom by default)
    func gradientOverlay(
        color: Color = .white,
        height: CGFloat = 200,
        edge: Edge = .bottom
    ) -> some View {
        modifier(GradientOverlay(color: color, height: height, edge: edge))
    }
}
