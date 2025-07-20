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
    @State var validationError: String? = nil

    func inputFieldView() -> some View {
        TextField(
            fieldConfig.label,
            text: $text,
            prompt: Text("Enter \(fieldConfig.label)")
        )
        .keyboardType(.default)
        .textFieldStyle((.capsule(text: $text, isValid: !isValidationWarningVisible)))
        .onSubmit {
            self.validationError = self.validateInput(text)
        }
    }
}
