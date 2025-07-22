//
//  KYCConfig.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation
import SwiftUICore

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
    }
}

extension FieldConfig.ValueType {
    private func genericCreator<Value, V: View>(
        _ valueType: Value.Type,
        viewProvider: @escaping () -> V
    ) -> FieldFactory.FieldCreator {
        { config in
            let vm = FieldViewModel<Value>(config: config)
            let view = viewProvider().environment(vm)
            return (AnyView(view), vm)
        }
    }
    
    var creator: FieldFactory.FieldCreator {
        switch self {
        case .text, .number:
            return genericCreator(String.self) { TextInputField() }
        case .date:
            return genericCreator(DateComponents.self) { DateInputField() }
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
