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

struct CapsuleTextFieldStyle: TextFieldStyle {
    @Environment(\.isEnabled) private var isEnabled
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let showClear = isFocused && !text.isEmpty
        let foregroundColor: Color = isEnabled ? .primary : .secondary

        configuration
            .foregroundStyle(foregroundColor)
            .overlay(alignment: .trailing) {
                if showClear {
                    ClearButton { text = "" }
                }
            }
            .focused($isFocused)
            .dynamicFormStroke(isFocused: isFocused, isDisabled: !isEnabled, isValid: isValid)
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
