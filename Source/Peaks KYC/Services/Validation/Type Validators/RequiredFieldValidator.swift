//
//  RequiredFieldValidator.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

struct RequiredFieldValidator: Validator {
    func validate(value: Any?) throws {
        if let stringValue = value as? String, !stringValue.isEmpty {
            return
        }
        
        if let anyValue = value, !(anyValue is String) {
            return
        }
        
        throw ValidationError(message: "This field is required.")
    }
}

