//
//  APIService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//


import Foundation

// MARK: - API Protocol

/// Protocol defining real vs. mock API implementations.
protocol APIService {
    /// Fetches the NL user profile.
    /// - Returns: NLUserProfile parsed from JSON.
    func fetchNLUserProfile() async throws -> MockAPIUserProfile
}

// MARK: - Mock Implementation

/// A mock API client that simulates network latency and returns hardcoded data.
final class MockAPI: APIService {
    static let shared = MockAPI()
    private init() {}

    /// Simulates a network call to `/api/nl-user-profile` with a 1-second delay.
    func fetchNLUserProfile() async throws -> MockAPIUserProfile {
        // 1. Simulate 0.5 second of network latency
        try await Task.sleep(nanoseconds: 500_000_000)

        // 2. Hard-coded JSON response
        let json = """
        {
            "firstName": "Jan",
            "lastName": "Jansen",
            "birthDate": "1985-04-15T00:00:00Z"
        }
        """.data(using: .utf8)!

        // 3. Decode into our model
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MockAPIUserProfile.self, from: json)
    }
}
