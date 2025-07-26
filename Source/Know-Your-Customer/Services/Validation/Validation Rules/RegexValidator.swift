//
//  RegexValidator.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import Foundation

// Ensures a string matches the provided regular expression.
struct RegexValidator: Validator {
    let pattern: String
    let errorMessage: String

    func validate(value: Any?) throws {
        // Don't validate empty fields, that's the job of `RequiredFieldValidator`
        guard let stringValue = value as? String, !stringValue.isEmpty else {
            return
        }

        if stringValue.range(of: pattern, options: .regularExpression) == nil {
            throw ValidationError(message: errorMessage)
        }
    }
}
