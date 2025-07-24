//
//  FormBuildingService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 24/07/25.
//

import Foundation

struct FormFactoryService {
    private let configLoader: ConfigLoaderService
    private let fieldFactory: FieldFactory

    init(configLoader: ConfigLoaderService, fieldFactory: FieldFactory) {
        self.configLoader = configLoader
        self.fieldFactory = fieldFactory
    }

    func buildForm(for country: SupportedCountry) async throws -> [FormField] {
        let result = try await configLoader.loadData(for: country)
        let fields = fieldFactory.makeFields(
            from: result.config.fields,
            prefilledValues: result.prefilledValues
        )
        return fields
    }
}
