//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct TextInputField: InputFieldRepresentable {
    @Binding var text: String
    let fieldConfig: FieldConfig
    
    func inputFieldView() -> some View {
        TextField(
            fieldConfig.label,
            text: $text,
            prompt: Text("Enter \(fieldConfig.label)")
        )
        .keyboardType(.default)
        .textFieldStyle((.capsule(text: $text, isValid: isValid)))
    }
}
