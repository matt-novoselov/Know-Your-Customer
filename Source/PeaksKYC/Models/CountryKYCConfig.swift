//
//  KYCConfig.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

// Describes the fields required for a country's KYC process.
struct CountryKYCConfig: Decodable {
    let country: String
    let fields: [FieldConfig]
}

// Configuration for a single input field.
struct FieldConfig: Decodable, Identifiable {
    let id: String
    let label: String
    let required: Bool
    let type: FieldDataType
    let validation: ValidationConfig?
}

extension FieldConfig {
    enum FieldDataType: String, Decodable {
        case text, number, date
    }
}

extension FieldConfig {
    struct ValidationConfig: Decodable {
        let regex: String?
        let message: String?
        let minLength, maxLength: Int?
        let minValue, maxValue: Int?
    }
}
