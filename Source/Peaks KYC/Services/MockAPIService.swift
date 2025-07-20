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

// 2️⃣ Make your mock concrete type conform
final class NLMockAPIService: MockAPIConformable {
    func fetchUserProfile(from url: String) async throws -> MockAPIUserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        let json = """
        {
            "firstName": "Jan",
            "lastName": "Jansen",
            "birthDate": "1985-04-15T00:00:00Z"
        }
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(MockAPIUserProfile.self, from: json)
    }
}

// Your ViewModel holds a protocol reference
@Observable
class MockAPIViewModel {
    var profile: MockAPIUserProfile?
    private let service: MockAPIConformable

    init(service: MockAPIConformable) {
        self.service = service
    }

    func loadProfile(from url: String) async {
        do {
            profile = try await service.fetchUserProfile(from: url)
        } catch {
            print("Fetch error:", error)
        }
    }
}
