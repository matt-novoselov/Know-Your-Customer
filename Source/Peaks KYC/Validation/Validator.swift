import Foundation

/// Represents a validation error with a user-friendly message.
struct ValidationError: Error {
    let message: String
}

/// A protocol defining a validation strategy for a given value.
protocol Validator {
    /// Validates a given value.
    /// - Parameter value: The value to validate, cast as `Any?`.
    /// - Throws: A `ValidationError` if the validation fails.
    func validate(value: Any?) throws
}
