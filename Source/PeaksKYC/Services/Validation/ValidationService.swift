//
//  ValidationService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import Foundation

// Runs validators for each field and surfaces the first error.
class ValidationService {

    /// Validates a single field and returns an error message if invalid.
    /// - Parameter field: The field to validate.
    /// - Returns: An optional `String` containing the first validation error message.
    func validate(fieldConfig: FieldConfig, value: Any?) -> String? {
        let validators = ValidatorFactory.validators(for: fieldConfig)

        for validator in validators {
            do {
                try validator.validate(value: value)
            } catch let error as ValidationError {
                return error.message
            } catch {
                return error.localizedDescription
            }
        }

        // All validators passed
        return nil
    }
}
