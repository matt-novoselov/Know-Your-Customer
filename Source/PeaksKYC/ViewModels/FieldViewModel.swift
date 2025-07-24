//
//  FieldViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

protocol FieldViewModelProtocol: Observable, Identifiable {
    var config: FieldConfig { get }
    var error: String? { get }
    var hasErrors: Bool { get }
    var isReadOnly: Bool { get }
    var displayValue: String { get }
    func validate()
}

@Observable
final class FieldViewModel<Value>: FieldViewModelProtocol {
    let config: FieldConfig
    var value: Value?
    var error: String?
    var hasErrors: Bool { error != nil }
    var id: String { config.id }
    let isReadOnly: Bool

    private let validationService: ValidationService

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    init(
        config: FieldConfig,
        preFilledValue: Value? = nil,
        validationService: ValidationService,
    ) {
        self.config = config
        self.value = preFilledValue
        self.validationService = validationService
        self.isReadOnly = preFilledValue != nil
    }

    var displayValue: String {
        guard let value = value else { return "N/A" }
        if let str = value as? String {
            return str
        }
        if let comps = value as? DateComponents,
           let date = Calendar.current.date(from: comps) {
            return dateFormatter.string(from: date)
        }
        return "\(value)"
    }

    func validate() {
        error = validationService.validate(fieldConfig: config, value: value)
    }
}
