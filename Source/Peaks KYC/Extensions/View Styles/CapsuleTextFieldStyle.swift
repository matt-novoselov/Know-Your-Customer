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
        let isClearButtonVisible = isFocused && !text.isEmpty
        
        configuration
            .overlay(alignment: .trailing) {
                if isClearButtonVisible {
                    ClearButton { self.text = "" }
                }
            }
            .focused($isFocused)
            .dynamicFormStroke(isFocused: isFocused, isValid: isValid)
            .animation(.spring(duration: 0.4), value: isClearButtonVisible)
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
