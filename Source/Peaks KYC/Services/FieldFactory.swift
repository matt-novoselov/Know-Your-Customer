//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

#warning("Refactor file")
struct FieldFactory {
    typealias FieldCreator = (FieldConfig, ValidationService) -> (view: AnyView, viewModel: any FieldViewModelProtocol)
    let validationService: ValidationService

    private func genericCreator<Value, V: View>(
        _ valueType: Value.Type,
        prefilledValue: Value? = nil,
        viewProvider: @escaping () -> V
    ) -> FieldCreator {
        { config, validationService in
            let viewModel = FieldViewModel<Value>(
                config: config,
                preFilledValue: prefilledValue,
                validationService: validationService
            )
            let view = viewProvider().environment(viewModel)
            return (AnyView(view), viewModel)
        }
    }

    private func creator(
        for dataType: FieldConfig.FieldDataType,
        prefilledValue: Any?
    ) -> FieldCreator {
        let value = prefilledValue as? String

        switch dataType {
        case .text, .number:
            return makeTextCreator(value)
        case .date:
            return makeDateCreator(value)
        }
    }

    private func makeTextCreator(_ value: String?) -> FieldCreator {
        genericCreator(String.self, prefilledValue: value) { TextInputField() }
    }

    private func makeDateCreator(_ isoString: String?) -> FieldCreator {
        let components = isoString
            .flatMap { Self.isoFormatter.date(from: $0) }
            .map { $0.yearMonthDay }
        return genericCreator(DateComponents.self, prefilledValue: components) {
            DateInputField()
        }
    }

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter
    }()

    func makeFields(
        from configs: [FieldConfig],
        prefilledValues: [APIUserProfile.FieldEntries]
    ) -> ([AnyView], [any FieldViewModelProtocol]) {
        var views: [AnyView] = []
        var viewModels: [any FieldViewModelProtocol] = []

        configs.forEach { config in
            let raw = prefilledValues.first(where: { $0.id == config.id })?.value
            let (view, viewModel) = creator(for: config.type, prefilledValue: raw)(config, validationService)
            views.append(view)
            viewModels.append(viewModel)
        }

        return (views, viewModels)
    }
}
