//
//  APIService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI
import Foundation

// Define your service protocol
protocol MockAPIConformable {
    func fetchUserProfile(from url: String) async throws -> MockAPIUserProfile
}

// Make your mock concrete type conform
final class NLMockAPIService: MockAPIConformable {
    func fetchUserProfile(from url: String) async throws -> MockAPIUserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        // swiftlint:disable:next non_optional_string_data_conversion
        let json = """
        {
          "fields": [
            { "id": "first_name",  "value": "Jan" },
            { "id": "last_name",   "value": "Jansen" },
            { "id": "birth_date",  "value": "2025-07-23" }
          ]
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MockAPIUserProfile.self, from: json)
    }
}
