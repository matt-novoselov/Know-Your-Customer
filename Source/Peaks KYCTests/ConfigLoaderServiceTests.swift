import Testing
@testable import Peaks_KYC
import Foundation

@Suite("ConfigLoaderService")
struct ConfigLoaderServiceTests {
    private func makeBundle(yaml: String, fileName: String = "NL.yaml") throws -> Bundle {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let plist = dir.appendingPathComponent("Info.plist")
        try Data("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict></dict></plist>".utf8).write(to: plist)
        try Data(yaml.utf8).write(to: dir.appendingPathComponent(fileName))
        return Bundle(url: dir)!
    }

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
        let bundle = try makeBundle(yaml: yaml)
        let loader = YAMLConfigLoader(bundle: bundle)
        let service = ConfigLoaderService(configurationLoader: loader)
        let result = try await service.loadData(for: .netherlands)
        #expect(result.config.country == "NL")
        #expect(result.prefilledValues.count == 3)
    }

    @Test("throws for missing file")
    func testMissingFile() async throws {
        let bundle = try makeBundle(yaml: "", fileName: "Other.yaml")
        let loader = YAMLConfigLoader(bundle: bundle)
        let service = ConfigLoaderService(configurationLoader: loader)

        await #expect(throws: YAMLConfigLoader.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }

    @Test("throws for invalid yaml")
    func testInvalidYAML() async throws {
        let bundle = try makeBundle(yaml: "invalid: [", fileName: "NL.yaml")
        let loader = YAMLConfigLoader(bundle: bundle)
        let service = ConfigLoaderService(configurationLoader: loader)

        await #expect(throws: YAMLConfigLoader.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }
}
