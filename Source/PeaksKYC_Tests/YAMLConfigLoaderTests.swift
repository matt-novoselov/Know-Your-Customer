import Testing
@testable import PeaksKYC
import Foundation

@Suite("YAMLConfigLoader")
struct YAMLConfigLoaderTests {
    // Exercises the YAML file decoding helper.

    @Test("load success")
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

    @Test("file not found")
    func testFileNotFound() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: ["test.yaml": ""])
        let loader = YAMLFileDecoder(bundle: bundle)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await loader.load(CountryKYCConfig.self, from: "missing.yaml")
        }
    }

    @Test("decoding failure")
    func testDecodingFailure() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: ["test.yaml": "invalid:"])
        let loader = YAMLFileDecoder(bundle: bundle)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await loader.load(CountryKYCConfig.self, from: "test.yaml")
        }
    }
}
