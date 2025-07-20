//
//  FocusStroke.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

enum CornerStyle {
    case capsule, roundedRect

    var cornerRadius: CGFloat {
        switch self {
        case .capsule:  return .infinity
        case .roundedRect:  return 23
        }
    }
}

struct DynamicStroke: ViewModifier {
    let isFocused: Bool
    let style: CornerStyle
    let focusColor: Color
    let idleColor: Color
    let padding: CGFloat

    private var strokeColor: Color { isFocused ? focusColor : idleColor }
    private var strokeWidth: Double { isFocused ? 2 : 0.5 }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .animation(.spring(response: 0.4), value: isFocused)
            )
    }
}

extension View {
    func dynamicStroke(
        isFocused: Bool,
        style: CornerStyle = .capsule,
        focusColor: Color = .primary,
        idleColor: Color = .secondary,
        padding: CGFloat = 20
    ) -> some View {
        modifier(DynamicStroke(
            isFocused: isFocused,
            style: style,
            focusColor: focusColor,
            idleColor: idleColor,
            padding: padding
        ))
    }
}
