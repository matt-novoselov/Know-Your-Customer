//
//  KYCConfig.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

struct ConfigModel: Decodable {
    let country: String
    let fields: [FieldConfig]
}

struct FieldConfig: Decodable, Identifiable {
    let id: String
    let label: String
    let required: Bool
    let type: FieldType
    let validation: ValidationConfig?
}

enum FieldType: String, Decodable {
    case text, number, date

    /// A default “empty” value for each field type
    var initialValue: Any? {
        switch self {
        case .text, .number:
            return ""
        case .date:
            return nil
        }
    }
}

struct ValidationConfig: Decodable {
    let regex: String?
    let message: String?
    let minLength, maxLength: Int?
    let minValue, maxValue: Int?
}
