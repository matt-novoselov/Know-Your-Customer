import Testing
@testable import Peaks_KYC
import Foundation

@Suite("ConfigLoaderService")
struct ConfigLoaderServiceTests {
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """

    private func makeBundle(yaml: String, fileName: String = "NL.yaml") throws -> Bundle {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let plist = dir.appendingPathComponent("Info.plist")
        try Data("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict></dict></plist>".utf8).write(to: plist)
        try Data(yaml.utf8).write(to: dir.appendingPathComponent(fileName))
        try Data(profileYAML.utf8).write(to: dir.appendingPathComponent("MockUserProfile.yaml"))
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
        let loader = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)
        let result = try await service.loadData(for: .netherlands)
        #expect(result.config.country == "NL")
        #expect(result.prefilledValues.count == 3)
    }

    @Test("throws for missing file")
    func testMissingFile() async throws {
        let bundle = try makeBundle(yaml: "", fileName: "Other.yaml")
        let loader = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }

    @Test("throws for invalid yaml")
    func testInvalidYAML() async throws {
        let bundle = try makeBundle(yaml: "invalid: [", fileName: "NL.yaml")
        let loader = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(loader: loader)
        let service = ConfigLoaderService(configurationLoader: loader, apiRequestService: apiService)

        await #expect(throws: YAMLFileDecoder.ServiceError.self){
            try await service.loadData(for: .netherlands)
        }
    }
}
