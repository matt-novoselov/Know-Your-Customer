//
//  ValidatorFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

struct ValidatorFactory {
    // Creates validators from field configuration.
    static func validators(for config: FieldConfig?) -> [Validator] {
        guard let config = config else {
            return []
        }

        var validators: [Validator] = []

        if config.required == true {
            validators.append(RequiredFieldValidator())
        }

        if config.type == .number {
            let regex = #"^\d+$"#
            validators.append(RegexValidator(pattern: regex, errorMessage: "Must be a number."))
        }

        guard let validationConfig = config.validation else {
            return validators
        }

        if let regex = validationConfig.regex {
            let validator = RegexValidator(
                pattern: regex,
                errorMessage: validationConfig.message ?? "Invalid format."
            )
            validators.append(validator)
        }

        if validationConfig.minLength != nil || validationConfig.maxLength != nil {
            let validator = LengthValidator(
                minLength: validationConfig.minLength,
                maxLength: validationConfig.maxLength
            )
            validators.append(validator)
        }

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
