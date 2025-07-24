//
//  DependencyContainer.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

@Observable
final class DependencyContainer {
    // Creates and shares view models across the app.
    let formManagerViewModel: FormViewModel
    let navigationViewModel: NavigationViewModel
    let accessibilityViewModel: AccessibilityViewModel

    init() {
        let validationService = ValidationService()
        let fieldFactory = FieldFactory(validationService: validationService)
        let configLoaderService = ConfigLoaderService()
        let formBuildingService = FormFactoryService(configLoader: configLoaderService, fieldFactory: fieldFactory)

        self.formManagerViewModel = FormViewModel(
            validationService: validationService,
            formBuildingService: formBuildingService
        )
        self.navigationViewModel = NavigationViewModel()
        self.accessibilityViewModel = AccessibilityViewModel()
    }
}
