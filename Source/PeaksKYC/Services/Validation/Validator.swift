//
//  Validator.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import Foundation

/// Represents a validation error.
struct ValidationError: Error {
    // Error produced by a failed validator.
    let message: String
}

/// A protocol defining a validation strategy for a given value.
protocol Validator {
    /// Validates a given value.
    /// - Parameter value: The value to validate, cast as `Any?`.
    /// - Throws: A `ValidationError` if the validation fails.
    func validate(value: Any?) throws
}
