//
//  APIService.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI
import Foundation

private let mockProfileFileName = "MockUserProfile.yaml"

// Simulates fetching user profile data from a remote endpoint.
struct APIRequestService {
    private let loader: YAMLFileDecoder
    private let fileName: String

    init(fileDecoder: YAMLFileDecoder = .init(), fileName: String = mockProfileFileName) {
        self.loader = fileDecoder
        self.fileName = fileName
    }

    func fetchUserProfile(from url: String) async throws -> APIUserProfile {
        try await Task.sleep(nanoseconds: 500_000_000)
        return try await loader.load(APIUserProfile.self, from: fileName)
    }
}
