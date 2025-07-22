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
        case .capsule:  return .greatestFiniteMagnitude
        case .roundedRect:  return 23
        }
    }
}

struct DynamicStroke: ViewModifier {
    let isFocused: Bool
    let isDisabled: Bool
    let style: CornerStyle
    let focusColor: Color
    let idleColor: Color
    let padding: CGFloat

    func body(content: Content) -> some View {
        let strokeColor = isFocused ? focusColor : idleColor
        let backgroundColor = isDisabled ? Color(.quaternarySystemFill) : .clear
        let strokeWidth = isFocused ? 2.0 : 0.5
        let shape = RoundedRectangle(cornerRadius: style.cornerRadius)

        content
            .padding(padding)
            .background {
                shape
                    .foregroundStyle(backgroundColor)
            }
            .overlay {
                shape
                    .stroke(strokeColor, lineWidth: strokeWidth)
                    .animation(.spring(response: 0.4), value: isFocused)
            }
    }
}

extension View {
    func dynamicStroke(
        isFocused: Bool,
        isDisabled: Bool = false,
        style: CornerStyle = .capsule,
        focusColor: Color = .primary,
        idleColor: Color = .secondary,
        padding: CGFloat = 20
    ) -> some View {
        modifier(DynamicStroke(
            isFocused: isFocused,
            isDisabled: isDisabled,
            style: style,
            focusColor: focusColor,
            idleColor: idleColor,
            padding: padding
        ))
    }
}
