//
//  APIService.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

private let jsonConfig =
"""
{
  "fields": [
    { "id": "first_name",  "value": "Jan" },
    { "id": "last_name",   "value": "Jansen" },
    { "id": "birth_date",  "value": "1990-07-23" }
  ]
}
"""

final class APIRequestService {
    func fetchUserProfile(from url: String) async throws -> APIUserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        let json = jsonConfig.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(APIUserProfile.self, from: json)
    }
}
