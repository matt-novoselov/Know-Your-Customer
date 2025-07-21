// In Source/Peaks KYC/Validation/RequiredFieldValidator.swift

struct RequiredFieldValidator: Validator {
    func validate(value: Any?) throws {
        if let stringValue = value as? String, !stringValue.isEmpty {
            return
        }
        
        func isNilOptional(_ any: Any) -> Bool {
            let mirror = Mirror(reflecting: any)
            return mirror.displayStyle == .optional && mirror.children.isEmpty
        }
        
        if let anyValue = value, !(anyValue is String), !isNilOptional(anyValue) {
            return
        }
        
        throw ValidationError(message: "This field is required.")
    }
}

