//
//  CountryData.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

enum CountryBehavior {
    /// Default: render all fields manually/editable
    case manual

    /// Fetch a user profile from an API
    case prepopulated(
        endpoint: URL
    )
}

struct CountryMetadata {
    let name: String
    let flag: Image
    let yamlFileName: String
    let behavior: CountryBehavior

    init(name: String, flag: Image, yamlFileName: String, behavior: CountryBehavior = .manual) {
        self.name = name
        self.flag = flag
        self.yamlFileName = yamlFileName
        self.behavior = behavior
    }
}

enum SupportedCountry: CaseIterable {
    case netherlands
    case germany
    case usa
    case debug

    var data: CountryMetadata {
        switch self {
        case .netherlands:
            return CountryMetadata(
                name: "The Netherlands",
                flag: Image(.netherlandsFlag),
                yamlFileName: "NL.yaml",
                behavior: .prepopulated(endpoint: URL(string: "https://peaks.com/api/nl-user-profile")!)
            )
        case .germany:
            return CountryMetadata(
                name: "Germany",
                flag: Image(.germanyFlag),
                yamlFileName: "DE.yaml"
            )
        case .usa:
            return CountryMetadata(
                name: "United States of America",
                flag: Image(.usaFlag),
                yamlFileName: "US.yaml"
            )
        case .debug:
            return CountryMetadata(
                name: "Debug Country",
                flag: Image(.pirateFlag),
                yamlFileName: "DEBUG.yaml"
            )
        }
    }
}
