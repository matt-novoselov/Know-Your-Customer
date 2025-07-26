//
//  ValueRangeValidator.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

// Validates numeric input falls within optional bounds.
struct ValueRangeValidator: Validator {
    let minValue: Int?
    let maxValue: Int?

    func validate(value: Any?) throws {
        guard let stringValue = value as? String, let doubleValue = Int(stringValue) else {
            return // Not a number, or empty.
        }

        if let minValue = minValue, doubleValue < minValue {
            throw ValidationError(message: "Value must be at least \(minValue).")
        }

        if let maxValue = maxValue, doubleValue > maxValue {
            throw ValidationError(message: "Value cannot be more than \(maxValue).")
        }
    }
}
