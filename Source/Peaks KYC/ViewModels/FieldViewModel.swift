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
    func validate() async
}


@Observable
final class FieldViewModel<Value>: AnyFieldViewModel {
    let config: FieldConfig
    var value: Value? = nil
    var error: String? = nil
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
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()
    
    init(config: FieldConfig, preFilledValue: Value? = nil) {
        self.config = config
        
        if let preFilledValue {
            self.value = preFilledValue
        }
        
        self.isReadOnly = preFilledValue != nil
    }
    
#warning("Remove init of ValidationService")
    func validate() async {
        let service = ValidationService()
        let error = await service.validate(field: config, value: value)
        self.error = error
    }
}
