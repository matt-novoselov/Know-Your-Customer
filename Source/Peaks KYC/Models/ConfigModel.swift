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

struct FieldConfig: Decodable {
    let id: String
    let label: String
    let required: Bool
    let type: FieldType
    let validation: ValidationConfig?
}

enum FieldType: String, Decodable {
    case text, number, date
}

struct ValidationConfig: Decodable {
    let regex: String?
    let message: String?
    let minLength, maxLength: Int?
    let minValue, maxValue: Double?
}
