//
//  LengthValidator.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

// Validates a string's length against optional bounds.
struct LengthValidator: Validator {
    let minLength: Int?
    let maxLength: Int?

    func validate(value: Any?) throws {
        guard let stringValue = value as? String, !stringValue.isEmpty else {
            return
        }

        if let minLength = minLength, stringValue.count < minLength {
            throw ValidationError(message: "Must be at least \(minLength) characters long.")
        }

        if let maxLength = maxLength, stringValue.count > maxLength {
            throw ValidationError(message: "Cannot be more than \(maxLength) characters long.")
        }
    }
}
