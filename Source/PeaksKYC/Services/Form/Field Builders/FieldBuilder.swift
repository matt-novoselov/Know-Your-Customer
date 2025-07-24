import SwiftUI

protocol FieldBuilder {
    // Factory interface used to create concrete form fields.
    func build(
        config: FieldConfig,
        prefilledValue: Any?,
        validationService: ValidationService
    ) -> FormField
}
