//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct TextInputField: InputFieldRepresentable {
    @Environment(FieldViewModel<String>.self) var viewModel
    @State var validationError: String? = nil
    
    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel
        let isValid = !viewModel.hasErrors
        
        TextField(
            viewModel.config.label,
            text: $viewModel.value,
            prompt: Text("Enter \(viewModel.config.label)")
        )
        .keyboardType(.default)
        .textFieldStyle((.capsule(text: $viewModel.value, isValid: isValid)))
        .onSubmit {
            self.viewModel.validate()
        }
    }
}
