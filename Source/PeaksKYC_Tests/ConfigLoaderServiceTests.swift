//
//  ConfigLoaderServiceTests.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import PeaksKYC
import Foundation

@Suite("ConfigLoaderService")
struct ConfigLoaderServiceTests {
    // Ensures YAML config and prepopulated data are loaded correctly.
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """


    @Test("loadData happy path")
    func testLoadSuccess() async throws {
        let yaml = """
        country: NL
        fields:
          - id: first_name
            label: First
            type: text
            required: true
        """
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": yaml,
            "MockUserProfile.yaml": profileYAML
        ])
        let fileDecoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: fileDecoder)
        let service = ConfigLoaderService(fileDecoder: fileDecoder, apiRequestService: apiService)
        let result = try await service.loadData(for: .netherlands)
        #expect(result.config.country == "NL")
        #expect(result.prefilledValues.count == 3)
    }

    @Test("throws for missing file")
    func testMissingFile() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "Other.yaml": "",
            "MockUserProfile.yaml": profileYAML
        ])
        let fileDecoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: fileDecoder)
        let service = ConfigLoaderService(fileDecoder: fileDecoder, apiRequestService: apiService)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }

    @Test("throws for invalid yaml")
    func testInvalidYAML() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "NL.yaml": "invalid: [",
            "MockUserProfile.yaml": profileYAML
        ])
        let fileDecoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: fileDecoder)
        let service = ConfigLoaderService(fileDecoder: fileDecoder, apiRequestService: apiService)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }

    @Test("surfaces api fetch failure")
    func testAPIFetchFailure() async throws {
        let yaml = """
        country: NL
        fields: []
        """
        // Intentionally omit MockUserProfile.yaml to trigger API failure
        let bundle = try makeTemporaryBundle(yamlFiles: ["NL.yaml": yaml])
        let fileDecoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: fileDecoder)
        let service = ConfigLoaderService(fileDecoder: fileDecoder, apiRequestService: apiService)

        await #expect(throws: ConfigLoaderService.ServiceError.self) {
            try await service.loadData(for: .netherlands)
        }
    }
}
