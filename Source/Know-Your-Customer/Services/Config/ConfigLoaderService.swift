//
//  ConfigLoaderService.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

// Loads KYC form configuration and any prepopulated user data.
struct ConfigLoaderService {
    struct LoadResult {
        let config: CountryKYCConfig
        let prefilledValues: [APIUserProfile.FieldEntries]
    }

    enum ServiceError: Error {
        case prepopulatedDataFetchFailed(underlying: Error)
    }

    private let fileDecoder: YAMLFileDecoder
    private let apiRequestService: APIRequestService

    init(fileDecoder: YAMLFileDecoder = .init(), apiRequestService: APIRequestService = .init()) {
        self.fileDecoder = fileDecoder
        self.apiRequestService = apiRequestService
    }

    // Load config and prefilled values (if any) for the selected country
    func loadData(for country: SupportedCountry) async throws -> LoadResult {
        let config = try await fileDecoder.load(CountryKYCConfig.self, from: country.data.yamlFileName)

        var prefilledValues: [APIUserProfile.FieldEntries] = []
        if case let .prepopulated(endpoint) = country.data.dataInputStrategy {
            do {
                prefilledValues = try await apiRequestService.fetchUserProfile(from: endpoint.absoluteString).fields
            } catch {
                throw ServiceError.prepopulatedDataFetchFailed(underlying: error)
            }
        }

        return LoadResult(config: config, prefilledValues: prefilledValues)
    }
}
