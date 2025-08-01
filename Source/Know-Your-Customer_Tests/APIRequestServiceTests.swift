//
//  APIRequestServiceTests.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
import Foundation
@testable import Know_Your_Customer

@Suite("APIRequestService")
struct APIRequestServiceTests {
    // Tests loading of mocked API profile data.
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """

    @Test("Decodes Mock YAML")
    func testFetch() async throws {
        let bundle = try makeTemporaryBundle(yamlFiles: ["MockUserProfile.yaml": profileYAML])
        let loader = YAMLFileDecoder(bundle: bundle)
        let service = APIRequestService(fileDecoder: loader)
        let profile = try await service.fetchUserProfile(from: "")
        #expect(profile.fields.count == 3)
        #expect(profile.fields[0].id == "first_name")
    }
}
