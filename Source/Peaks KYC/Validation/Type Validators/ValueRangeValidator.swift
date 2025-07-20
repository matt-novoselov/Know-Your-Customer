// In Source/Peaks KYC/Validation/ValueRangeValidator.swift

struct ValueRangeValidator: Validator {
    let minValue: Double?
    let maxValue: Double?

    func validate(value: Any?) throws {
        guard let stringValue = value as? String, let doubleValue = Double(stringValue) else {
            return // Not a number, or empty. Other validators will handle this.
        }

        if let minValue = minValue, doubleValue < minValue {
            throw ValidationError(message: "Value must be at least \(minValue).")
        }

        if let maxValue = maxValue, doubleValue > maxValue {
            throw ValidationError(message: "Value cannot be more than \(maxValue).")
        }
    }
}
