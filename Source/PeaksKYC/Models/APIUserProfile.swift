//
//  MockAPIUserProfile.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

struct APIUserProfile: Decodable {
    // Representation of a user profile returned by the API.
    let fields: [FieldEntries]
}

extension APIUserProfile {
    struct FieldEntries: Decodable, Identifiable {
        // Individual field/value pair.
        let id: String
        let value: String
    }
}
