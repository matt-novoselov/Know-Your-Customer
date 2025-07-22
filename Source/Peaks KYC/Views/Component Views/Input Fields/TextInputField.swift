//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

#warning("lost focus -> validate")
#warning("On continue button -> insocate that some firlds are not validated")
import SwiftUI

struct TextInputField: InputFieldRepresentable {
    @Environment(FieldViewModel<String>.self) var viewModel
    
    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel
        let isValid = !viewModel.hasErrors
        let textLabel = Text("Enter \(viewModel.config.label)")
        let keyboardType: UIKeyboardType = viewModel.config.type == .number ? .numbersAndPunctuation : .default
        
        TextField(
            viewModel.config.label,
            text: $viewModel.value,
            prompt: textLabel
        )
        .keyboardType(keyboardType)
        .textFieldStyle((.capsule(text: $viewModel.value, isValid: isValid)))
        .onSubmit {
            self.viewModel.validate()
        }
    }
}
