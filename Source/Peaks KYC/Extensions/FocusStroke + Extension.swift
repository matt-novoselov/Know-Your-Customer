//
//  FocusStroke.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct FocusStroke: ViewModifier {
    let isFocused: Bool
    let cornerRadius: CGFloat
    let focusColor: Color
    let idleColor: Color
    let padding: CGFloat

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isFocused ? focusColor : idleColor,
                            lineWidth: isFocused ? 2 : 0.5)
                    .animation(.spring(response: 0.4), value: isFocused)
            )
    }
}

extension View {
    func focusStroke(isFocused: Bool, cornerRadius: CGFloat = .infinity, focusColor: Color = .primary, idleColor: Color = .secondary, padding: CGFloat = 20) -> some View {
        modifier(FocusStroke(isFocused: isFocused, cornerRadius: cornerRadius, focusColor: focusColor, idleColor: idleColor, padding: padding))
    }
}
