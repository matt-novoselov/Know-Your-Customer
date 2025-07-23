//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

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
    ) -> ([AnyView], [any FieldViewModelProtocol]) {
        var views: [AnyView] = []
        var viewModels: [any FieldViewModelProtocol] = []

        for config in configs {
            let value = prefilledValues.first(where: { $0.id == config.id })?.value
            guard let builder = builders[config.type] else { continue }
            let result = builder.build(
                config: config,
                prefilledValue: value,
                validationService: validationService
            )
            views.append(result.view)
            viewModels.append(result.viewModel)
        }

        return (views, viewModels)
    }
}

private extension FieldFactory {
    static var defaultBuilders: [FieldConfig.FieldDataType: any FieldBuilder] {
        [
            .text: TextFieldBuilder(),
            .number: TextFieldBuilder(),
            .date: DateFieldBuilder(),
        ]
    }
}
