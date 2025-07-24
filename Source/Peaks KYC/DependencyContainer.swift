//
//  DependencyContainer.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

@Observable
final class DependencyContainer {
    let formManagerViewModel: FormManagerViewModel
    let navigationViewModel: NavigationViewModel

    init() {
        let validationService = ValidationService()
        let fieldFactory = FieldFactory(validationService: validationService)
        let configLoaderService = ConfigLoaderService()

        self.formManagerViewModel = FormManagerViewModel(
            configLoader: configLoaderService,
            validationService: validationService,
            fieldFactory: fieldFactory
        )
        self.navigationViewModel = NavigationViewModel()
    }
}
