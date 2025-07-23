//
//  ConfigLoaderService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

struct ConfigLoaderService {
    private let configurationLoader = CountryConfigLoaderService()
    private let apiRequestService = APIRequestService()

    func loadData(for country: Country) async throws -> (ConfigModel, [APIUserProfile.FieldEntries]) {
        let config = try configurationLoader.loadConfigForSelectedCountry(from: country.data.yamlFileName)

        var prefilledValues: [APIUserProfile.FieldEntries] = []
        if case let .prepopulated(endpoint) = country.data.behavior {
            do {
                prefilledValues = try await apiRequestService.fetchUserProfile(from: endpoint.absoluteString).fields
            } catch {
                print("Error fetching prepopulated data: \(error)")
            }
        }

        return (config, prefilledValues)
    }
}
