// In Source/Peaks KYC/Validation/RequiredFieldValidator.swift

struct RequiredFieldValidator: Validator {
    func validate(value: Any?) throws {
        if let stringValue = value as? String, !stringValue.isEmpty {
            return // valid non-empty String
        }

        #warning("")
        if let nonNil = value {
            let mirror = Mirror(reflecting: nonNil)
            let isNilOptional = mirror.displayStyle == .optional && mirror.children.isEmpty
            if !isNilOptional && !(nonNil is String) {
                return // valid non-nil, non-String
            }
        }

        throw ValidationError(message: "This field is required.")
    }
}

