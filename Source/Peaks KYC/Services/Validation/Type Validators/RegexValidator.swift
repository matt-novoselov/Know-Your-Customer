// In Source/Peaks KYC/Validation/RegexValidator.swift

import Foundation

struct RegexValidator: Validator {
    let pattern: String
    let errorMessage: String

    func validate(value: Any?) throws {
        guard let stringValue = value as? String, !stringValue.isEmpty else {
            return // Don't validate empty fields, that's the job of `RequiredFieldValidator`
        }
        
        if stringValue.range(of: pattern, options: .regularExpression) == nil {
            throw ValidationError(message: errorMessage)
        }
    }
}
