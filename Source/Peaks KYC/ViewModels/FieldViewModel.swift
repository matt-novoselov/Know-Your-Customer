//
//  FieldViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

// MARK: –– 1. Your protocol
protocol AnyFieldViewModel: Observable, Identifiable {
    var config: FieldConfig { get }
    var error: String? { get }
    var hasErrors: Bool { get }
    var isReadOnly: Bool { get }
    var displayValue: String { get }
    func validate()
}

@Observable
final class FieldViewModel<Value>: AnyFieldViewModel {
    let config: FieldConfig
    var value: Value?
    var error: String?
    var hasErrors: Bool { error != nil }
    var id: String { config.id }
    let isReadOnly: Bool
    var displayValue: String {
        guard let unwrapped = value else { return "N/A" }

        switch unwrapped {
        case let str as String:
            return str

        case let comps as DateComponents:
            guard let date = Calendar.current.date(from: comps) else {
                return "Invalid date"
            }
            return sharedFormatter.string(from: date)

        default:
            return "\(unwrapped)"
        }
    }

    // Shared formatter
    let sharedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(config: FieldConfig, preFilledValue: Value? = nil) {
        self.config = config

        if let preFilledValue {
            self.value = preFilledValue
        }

        self.isReadOnly = preFilledValue != nil
    }

#warning("Remove init of ValidationService")
    func validate() {
        let service = ValidationService()
        let error = service.validate(field: config, value: value)
        self.error = error
    }
}
