import SwiftUI

struct TextFieldBuilder: FieldBuilder {
    // Builds a simple text input field.
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
