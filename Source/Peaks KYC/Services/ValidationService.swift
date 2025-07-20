// In Source/Peaks KYC/Services/ValidationService.swift

import Foundation

class ValidationService {
    
    /// Validates a single field and returns an error message if invalid.
    /// - Parameter field: The field to validate.
    /// - Returns: An optional `String` containing the first validation error message.
    func validate(field: FieldConfig, value: Any?) -> String? {
        let validators = ValidatorFactory.validators(for: field)
        
        for validator in validators {
            do {
                try validator.validate(value: value)
            } catch let error as ValidationError {
                return error.message
            } catch {
                return error.localizedDescription
            }
        }
        
        return nil // All validators passed
    }
    
    /// Validates multiple fields and returns a dictionary of errors.
    /// - Parameter fields: An array of fields to validate.
    /// - Returns: A dictionary where the key is the field's `id` and the value is the error message.
    func validate(fields: [FieldConfig], values: [String: Any]) -> [String: String] {
        var errors: [String: String] = [:]
        
        for field in fields {
            let value = values[field.id]
            if let errorMessage = validate(field: field, value: value) {
                errors[field.id] = errorMessage
            }
        }
        
        return errors
    }
}
