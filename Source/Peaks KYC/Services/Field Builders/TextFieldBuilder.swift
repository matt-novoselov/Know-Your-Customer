import SwiftUI

struct TextFieldBuilder: FieldBuilder {
    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> (view: AnyView, viewModel: any FieldViewModelProtocol) {
        let value = prefilledValue as? String
        let viewModel = FieldViewModel<String>(
            config: config,
            preFilledValue: value,
            validationService: validationService
        )
        let view = TextInputField().environment(viewModel)
        return (AnyView(view), viewModel)
    }
}
