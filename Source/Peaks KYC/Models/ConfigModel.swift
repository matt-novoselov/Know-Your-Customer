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
    let type: ValueType
    let validation: ValidationConfig?
}

extension FieldConfig {
    enum ValueType: String, Decodable {
        case text, number, date

        /// A default “empty” value for each field type
        var initialValue: StoredValue {
            switch self {
            case .text, .number:
                return .text("")
            case .date:
                return .empty
            }
        }
    }

    /// Represents a value for any supported field type.
    enum StoredValue: CustomStringConvertible {
        case empty
        case text(String)
        case number(String)
        case date(DateComponents)

        private static let dateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.dateStyle = .medium
            return f
        }()

        public var description: String {
            switch self {
            case .empty:
                return ""
            case .text(let string), .number(let string):
                return string
            case .date(let components):
                if let date = Calendar.current.date(from: components) {
                    return Self.dateFormatter.string(from: date)
                } else {
                    return ""
                }
            }
        }
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
