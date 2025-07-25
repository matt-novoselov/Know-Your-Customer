//
//  PeaksTextFieldStyle.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

extension TextFieldStyle where Self == CapsuleTextFieldStyle {
    static func capsule(text: Binding<String>, isValid: Bool) -> Self {
        .init(text: text, isValid: isValid)
    }
}

// Custom text field style with dynamic border and clear button.
struct CapsuleTextFieldStyle: TextFieldStyle {
    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var isValid: Bool

    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        let showClear = isFocused && !text.isEmpty
        let foregroundColor: Color = isEnabled ? .primary : .secondary

        HStack {
            configuration

            ClearButton { text = "" }
                .opacity(showClear ? 1 : 0)
        }
        .foregroundStyle(foregroundColor)
        .focused($isFocused)
        .dynamicFieldStroke(isFocused: isFocused, isDisabled: !isEnabled, isValid: isValid)
        .animation(.spring(duration: 0.4), value: showClear)
    }

    private struct ClearButton: View {
        let action: () -> Void

        var body: some View {
            Button("Clear text", systemImage: "xmark", action: action)
                .labelStyle(.iconOnly)
                .foregroundStyle(.primary)
                .fontWeight(.medium)
        }
    }
}
