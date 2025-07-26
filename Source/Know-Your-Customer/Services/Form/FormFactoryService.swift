//
//  FormBuildingService.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

// Orchestrates loading YAML config and building field views.
struct FormFactoryService {
    private let configLoader: ConfigLoaderService
    private let fieldFactory: FieldFactory

    init(configLoader: ConfigLoaderService, fieldFactory: FieldFactory) {
        self.configLoader = configLoader
        self.fieldFactory = fieldFactory
    }

    /// Constructs Field Views / ViewModels for a selected country.
    /// Selected country is stored for checks later.
    func buildForm(for country: SupportedCountry) async throws -> LoadedForm {
        let result = try await configLoader.loadData(for: country)
        let fields = fieldFactory.makeFields(
            from: result.config.fields,
            prefilledValues: result.prefilledValues
        )
        let form = LoadedForm(
            fields: fields,
            country: country
        )
        return form
    }
}
