//
//  ValidatorFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

struct ValidatorFactory {
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
            validators.append(RegexValidator(pattern: regex, errorMessage: validationConfig.message ?? "Invalid format."))
        }
        
        if validationConfig.minLength != nil || validationConfig.maxLength != nil {
            validators.append(LengthValidator(minLength: validationConfig.minLength, maxLength: validationConfig.maxLength))
        }

        if validationConfig.minValue != nil || validationConfig.maxValue != nil {
            validators.append(ValueRangeValidator(minValue: validationConfig.minValue, maxValue: validationConfig.maxValue))
        }
        
        return validators
    }
}
