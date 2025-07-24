//
//  ConfigLoaderService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Foundation

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
