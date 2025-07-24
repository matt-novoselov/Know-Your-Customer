//
//  FieldFactory.swift
//  Peaks KYC
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

struct FieldFactory {
    let validationService: ValidationService
    private let builders: [FieldConfig.FieldDataType: any FieldBuilder]

    init(
        validationService: ValidationService,
        builders: [FieldConfig.FieldDataType: any FieldBuilder] = FieldFactory.defaultBuilders
    ) {
        self.validationService = validationService
        self.builders = builders
    }

    func makeFields(
        from configs: [FieldConfig],
        prefilledValues: [APIUserProfile.FieldEntries]
    ) -> [FormField] {
        let prefilledDictionary = Dictionary(
            uniqueKeysWithValues: prefilledValues.map { ($0.id, $0.value) }
        )
        var fields: [FormField] = []

        for config in configs {
            let value = prefilledDictionary[config.id]
            guard let builder = builders[config.type] else { continue }
            let result = builder.build(
                config: config,
                prefilledValue: value,
                validationService: validationService
            )
            fields.append(FormField(view: result.view, viewModel: result.viewModel))
        }

        return fields
    }
}

private extension FieldFactory {
    static var defaultBuilders: [FieldConfig.FieldDataType: any FieldBuilder] {
        [
            .text: TextFieldBuilder(),
            .number: TextFieldBuilder(),
            .date: DateFieldBuilder()
        ]
    }
}
