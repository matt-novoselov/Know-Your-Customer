//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

struct FieldFactory {
    typealias FieldCreator = (FieldConfig, ValidationService) -> (view: AnyView, viewModel: any FieldViewModelProtocol)

    let validationService: ValidationService

    func makeFields(from configs: [FieldConfig])
    -> ([AnyView], [any FieldViewModelProtocol]) {

        var views: [AnyView] = []
        var viewModels: [any FieldViewModelProtocol] = []

        configs.forEach { config in
            let (view, viewModel) = config.type.creator(config, validationService)
            views.append(view)
            viewModels.append(viewModel)
        }
        return (views, viewModels)
    }
}
