import Testing
@testable import Peaks_KYC
import Foundation

@Suite("YAMLConfigLoader")
struct YAMLConfigLoaderTests {
    private func makeBundle(with yaml: String, file: String = "test.yaml") throws -> Bundle {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let plist = dir.appendingPathComponent("Info.plist")
        try Data("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict></dict></plist>".utf8).write(to: plist)
        try Data(yaml.utf8).write(to: dir.appendingPathComponent(file))
        return Bundle(url: dir)!
    }

    @Test("load success")
    func testLoad() throws {
        let yaml = """
country: US
fields: []
"""
        let bundle = try makeBundle(with: yaml)
        let loader = YAMLConfigLoader(bundle: bundle)
        let cfg: CountryKYCConfig = try loader.load(CountryKYCConfig.self, from: "test.yaml")
        #expect(cfg.country == "US")
    }

    @Test("file not found")
    func testFileNotFound() throws {
        let bundle = try makeBundle(with: "")
        let loader = YAMLConfigLoader(bundle: bundle)
        do {
            _ = try loader.load(CountryKYCConfig.self, from: "missing.yaml")
            #expect(false, "should throw")
        } catch YAMLConfigLoader.ServiceError.fileNotFound(name: _) {
            #expect(true)
        }
    }

    @Test("decoding failure")
    func testDecodingFailure() throws {
        let bundle = try makeBundle(with: "invalid:")
        let loader = YAMLConfigLoader(bundle: bundle)
        do {
            _ = try loader.load(CountryKYCConfig.self, from: "test.yaml")
            #expect(false, "should throw")
        } catch YAMLConfigLoader.ServiceError.decodingFailed(underlying: _) {
            #expect(true)
        }
    }
}
