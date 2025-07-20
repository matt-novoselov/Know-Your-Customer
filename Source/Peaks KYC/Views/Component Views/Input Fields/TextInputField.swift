//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct TextInputField: InputFieldRepresentable {
    @Environment(FormFieldViewModel<String>.self) var formFieldViewModel
    @State var validationError: String? = nil

    func inputFieldView() -> some View {
        @Bindable var formFieldViewModel = formFieldViewModel
        
        TextField(
            formFieldViewModel.config.label,
            text: $formFieldViewModel.value,
            prompt: Text("Enter \(formFieldViewModel.config.label)")
        )
        .keyboardType(.default)
        .textFieldStyle((.capsule(text: $formFieldViewModel.value, isValid: !isValidationWarningVisible)))
        .onSubmit {
            self.formFieldViewModel.validate()
        }
    }
}
