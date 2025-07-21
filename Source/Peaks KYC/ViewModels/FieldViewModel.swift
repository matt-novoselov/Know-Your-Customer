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
    var valueAsAny: Any { get }
    var error: String? { get }
    var hasErrors: Bool { get }
    var isReadOnly: Bool { get }
    func validate()
}


@Observable
final class FieldViewModel<Value>: AnyFieldViewModel {
    let config: FieldConfig
    var value: Value
    var error: String? = nil
    var hasErrors: Bool { error != nil }
    var valueAsAny: Any { value }
    var id: String { config.id }
    let isReadOnly: Bool
    
    init(config: FieldConfig, preFilledValue: Value? = nil) {
        self.config = config
        self.value = config.type.initialValue as! Value
        
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
