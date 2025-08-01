//
//  FieldFactory.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

struct LoadedForm {
    let fields: [FormField]
    let country: SupportedCountry
}

struct FormField {
    let view: AnyView
    let viewModel: any FieldViewModelProtocol
}

// Converts field configs and values into concrete SwiftUI views.
struct FieldFactory {
    let validationService: ValidationService

    // Creates view models for each configured field.
    func makeFields(
        from configs: [FieldConfig],
        prefilledValues: [APIUserProfile.FieldEntries]
    ) -> [FormField] {
        let prefilledDict = Dictionary(
            uniqueKeysWithValues: prefilledValues.map { ($0.id, $0.value) }
        )
        return configs.compactMap { config in
            let value = prefilledDict[config.id]
            let builder = builder(for: config.type)
            let result = builder.build(
                config: config,
                prefilledValue: value,
                validationService: validationService
            )
            return FormField(view: result.view, viewModel: result.viewModel)
        }
    }
}

private extension FieldFactory {
    private func builder(for type: FieldConfig.FieldDataType) -> any FieldBuilder {
        switch type {
        case .text, .number:
            return TextFieldBuilder()
        case .date:
            return DateFieldBuilder()
        }
    }
}
