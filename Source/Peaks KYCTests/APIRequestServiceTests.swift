import Testing
@testable import Peaks_KYC

@Suite("APIRequestService")
struct APIRequestServiceTests {
    @Test("decodes mock json")
    func testFetch() async throws {
        let service = APIRequestService()
        let profile = try await service.fetchUserProfile(from: "")
        #expect(profile.fields.count == 3)
        #expect(profile.fields[0].id == "first_name")
    }
}
