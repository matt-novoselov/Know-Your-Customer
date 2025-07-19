//
//  PeaksTextFieldStyle.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

extension TextFieldStyle where Self == CapsuleTextFieldStyle {
    static func capsule(text: Binding<String>, isValid: Bool) -> Self { .init(text: text, isValid: isValid) }
}

struct CapsuleTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let isEmpty = text.isEmpty
        
        var focusColor: Color {
            isValid ? (isFocused || !isEmpty ? .primary : .secondary) : .red
        }
        
        var isFieldFocused: Bool {
            isFocused || !isValid
        }
        
        configuration
            .overlay(alignment: .trailing) {
                if isFocused && !isEmpty {
                    ClearButton { self.text = "" }
                }
            }
            .focused($isFocused)
            .dynamicStroke(isFocused: isFieldFocused, focusColor: focusColor)
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
