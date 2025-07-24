import Testing
import Foundation
@testable import Peaks_KYC

@Suite("APIRequestService")
struct APIRequestServiceTests {
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """

    private func makeBundle() throws -> Bundle {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let plist = dir.appendingPathComponent("Info.plist")
        try Data("<?xml version=\"1.0\" encoding=\"UTF-8\"?><plist version=\"1.0\"><dict></dict></plist>".utf8).write(to: plist)
        try Data(profileYAML.utf8).write(to: dir.appendingPathComponent("MockUserProfile.yaml"))
        return Bundle(url: dir)!
    }

    @Test("decodes mock yaml")
    func testFetch() async throws {
        let bundle = try makeBundle()
        let loader = YAMLFileDecoder(bundle: bundle)
        let service = APIRequestService(loader: loader)
        let profile = try await service.fetchUserProfile(from: "")
        #expect(profile.fields.count == 3)
        #expect(profile.fields[0].id == "first_name")
    }
}
