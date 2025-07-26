//
//  TextFieldBuilder.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// Builds a text input field.
struct TextFieldBuilder: FieldBuilder {
    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> FormField {
        let value = prefilledValue as? String
        let viewModel = FieldViewModel<String>(
            config: config,
            preFilledValue: value,
            validationService: validationService
        )
        let view = TextInputField().environment(viewModel)
        return FormField(view: AnyView(view), viewModel: viewModel)
    }
}
