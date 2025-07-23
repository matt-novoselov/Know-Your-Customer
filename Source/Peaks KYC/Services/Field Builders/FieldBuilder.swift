import SwiftUI

protocol FieldBuilder {
    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> (view: AnyView, viewModel: any FieldViewModelProtocol)
}
