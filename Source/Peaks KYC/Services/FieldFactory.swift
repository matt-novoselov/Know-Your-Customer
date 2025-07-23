//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI
import SwiftUICore

struct FieldFactory {
    typealias FieldCreator = (FieldConfig, ValidationService) -> (view: AnyView, viewModel: any FieldViewModelProtocol)

    let validationService: ValidationService

    private func genericCreator<Value, V: View>(
        _ valueType: Value.Type,
        viewProvider: @escaping () -> V
    ) -> FieldCreator {
        { config, validationService in
            let viewModel = FieldViewModel<Value>(config: config, validationService: validationService)
            let view = viewProvider().environment(viewModel)
            return (AnyView(view), viewModel)
        }
    }

    private func creator(for dataType: FieldConfig.FieldDataType) -> FieldCreator {
        switch dataType {
        case .text, .number:
            return genericCreator(String.self) { TextInputField() }
        case .date:
            return genericCreator(DateComponents.self) { DateInputField() }
        }
    }

    func makeFields(from configs: [FieldConfig])
    -> ([AnyView], [any FieldViewModelProtocol]) {
        var views: [AnyView] = []
        var viewModels: [any FieldViewModelProtocol] = []

        configs.forEach { config in
            let (view, viewModel) = creator(for: config.type)(config, validationService)
            views.append(view)
            viewModels.append(viewModel)
        }
        return (views, viewModels)
    }
}
