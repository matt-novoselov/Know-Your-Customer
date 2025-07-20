// In Source/Peaks KYC/Validation/RequiredFieldValidator.swift

struct RequiredFieldValidator: Validator {
    func validate(value: Any?) throws {
        if let stringValue = value as? String, !stringValue.isEmpty {
            return // Valid
        }
        
        if value != nil && !(value is String) {
            return // Valid for non-string types
        }
        
        // To make the message generic, we can use a default one.
        // In a real-world app, this could be localized.
        throw ValidationError(message: "This field is required.")
    }
}
