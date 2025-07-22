//
//  FieldFactory.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

struct FieldFactory {
    typealias FieldCreator = (FieldConfig) -> (view: AnyView, viewModel: any AnyFieldViewModel)

    static func makeFields(from configs: [FieldConfig])
    -> ([AnyView], [any AnyFieldViewModel]) {

        var views: [AnyView] = []
        var viewModels: [any AnyFieldViewModel] = []

        configs.forEach { config in
            let (view, viewModel) = config.type.creator(config)
            views.append(view)
            viewModels.append(viewModel)
        }
        return (views, viewModels)
    }
}
