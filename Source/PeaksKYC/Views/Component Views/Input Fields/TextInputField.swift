//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct TextInputField: InputFieldView {
    // Simple text entry field with validation hooks.
    @Environment(FieldViewModel<String>.self) var viewModel

    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel
        let isValid = !viewModel.hasErrors
        let textLabel = Text("Enter \(viewModel.config.label)")
        let keyboardType: UIKeyboardType = viewModel.config.type == .number ? .numberPad : .default
        let binding = Binding<String>(
            get: { viewModel.value ?? "" },
            set: { viewModel.value = $0.isEmpty ? nil : $0 }
        )

        TextField(
            viewModel.config.label,
            text: binding,
            prompt: textLabel
        )
        .keyboardType(keyboardType)
        .textFieldStyle((.capsule(text: binding, isValid: isValid)))
        .onSubmit {
            self.viewModel.validate()
        }
        .onDebouncedChange(of: viewModel.value) { _ in
            self.viewModel.validate()
        }
    }
}
