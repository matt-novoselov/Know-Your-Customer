//
//  MockAPIUserProfile.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

// Representation of a user profile returned by the Mock API.
struct APIUserProfile: Decodable {
    let fields: [FieldEntries]
}

extension APIUserProfile {
    // Individual field/value pair.
    struct FieldEntries: Decodable, Identifiable {
        let id: String
        let value: String
    }
}
