//
//  MockAPIUserProfile.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Foundation

/// Represents the user profile data we fetch for NL clients.
struct MockAPIUserProfile: Decodable {
    let firstName: String
    let lastName: String
    let birthDate: Date
}
