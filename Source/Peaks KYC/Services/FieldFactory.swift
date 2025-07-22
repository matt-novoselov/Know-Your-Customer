//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//


import SwiftUI

struct FieldFactory {
    typealias FieldCreator = (FieldConfig) -> (view: AnyView, viewModel: any AnyFieldViewModel)
    
    private static func genericCreator<Value, V: View>(
        _ valueType: Value.Type,
        viewProvider: @escaping () -> V
    ) -> FieldCreator {
        { config in
            let vm = FieldViewModel<Value>(config: config)
            let view = viewProvider().environment(vm)
            return (AnyView(view), vm)
        }
    }
    
    private static func creator(for type: FieldConfig.ValueType) -> FieldCreator {
        switch type {
        case .text, .number:
            return genericCreator(String.self) { TextInputField() }
        case .date:
            return genericCreator(Date?.self) { DateInputField() }
        }
    }
    
    static func makeFields(from configs: [FieldConfig])
    -> ([AnyView], [any AnyFieldViewModel]) {
        var views: [AnyView] = []
        var vms:   [any AnyFieldViewModel] = []
        
        configs.forEach { config in
            let build = creator(for: config.type)
            let (view, vm) = build(config)
            views.append(view)
            vms.append(vm)
        }
        return (views, vms)
    }
}
