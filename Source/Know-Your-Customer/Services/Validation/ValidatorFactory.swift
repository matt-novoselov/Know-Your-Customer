//
//  ValidatorFactory.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

// Creates validators from field configuration.
struct ValidatorFactory {
    static func validators(for config: FieldConfig?) -> [Validator] {
        guard let config = config else {
            return []
        }

        var validators: [Validator] = []

        // Required field validation.
        if config.required == true {
            validators.append(RequiredFieldValidator())
        }

        // Number fields are Text fields.
        // Here we validate that only numbers can be inputted.
        if config.type == .number {
            let regex = #"^\d+$"#
            validators.append(RegexValidator(pattern: regex, errorMessage: "Must be a number."))
        }

        // Additional Validators are appended below.
        guard let validationConfig = config.validation else {
            return validators
        }

        // Regex field validation.
        if let regex = validationConfig.regex {
            let validator = RegexValidator(
                pattern: regex,
                errorMessage: validationConfig.message ?? "Invalid format."
            )
            validators.append(validator)
        }

        // Length field validation.
        if validationConfig.minLength != nil || validationConfig.maxLength != nil {
            let validator = LengthValidator(
                minLength: validationConfig.minLength,
                maxLength: validationConfig.maxLength
            )
            validators.append(validator)
        }

        // Value field validation.
        if validationConfig.minValue != nil || validationConfig.maxValue != nil {
            let validator = ValueRangeValidator(
                minValue: validationConfig.minValue,
                maxValue: validationConfig.maxValue
            )
            validators.append(validator)
        }

        return validators
    }
}
