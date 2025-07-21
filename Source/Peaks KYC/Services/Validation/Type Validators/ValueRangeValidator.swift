//
//  ValueRangeValidator.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

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
