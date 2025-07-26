//
//  YAMLConfigLoaderTests.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import Know_Your_Customer
import Foundation

@Suite("YAML Config Loader")
struct YAMLConfigLoaderTests {
    // Exercises the YAML file decoding helper.

    @Test("Load Success")
    func testLoad() async throws {
        let yaml = """
        country: US
        fields: []
        """
        let bundle = try makeTemporaryBundle(yamlFiles: ["test.yaml": yaml])
        let loader = YAMLFileDecoder(bundle: bundle)
        let cfg: CountryKYCConfig = try await loader.load(CountryKYCConfig.self, from: "test.yaml")
        #expect(cfg.country == "US")
    }

    @Test("File Not Found")
    func testFileNotFound() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: ["test.yaml": ""])
        let loader = YAMLFileDecoder(bundle: bundle)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await loader.load(CountryKYCConfig.self, from: "missing.yaml")
        }
    }

    @Test("Decoding Failure")
    func testDecodingFailure() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: ["test.yaml": "invalid:"])
        let loader = YAMLFileDecoder(bundle: bundle)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await loader.load(CountryKYCConfig.self, from: "test.yaml")
        }
    }
}
