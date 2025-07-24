//
//  MockAPIUserProfile.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

struct APIUserProfile: Decodable {
    let fields: [FieldEntries]
}

extension APIUserProfile {
    struct FieldEntries: Decodable, Identifiable {
        let id: String
        let value: String
    }
}
