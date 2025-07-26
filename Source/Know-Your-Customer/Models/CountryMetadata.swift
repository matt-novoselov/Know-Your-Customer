//
//  CountryData.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

enum CountryDataInputStrategy {
    /// Default: render all fields manually/editable
    case manual

    /// Fetch a user profile from an API
    case prepopulated(
        endpoint: URL
    )
}

// Basic display info and data source for a supported country.
struct CountryMetadata {
    let name: String
    let flag: Image
    let yamlFileName: String
    let dataInputStrategy: CountryDataInputStrategy

    init(name: String, flag: Image, yamlFileName: String, dataInputStrategy: CountryDataInputStrategy = .manual) {
        self.name = name
        self.flag = flag
        self.yamlFileName = yamlFileName
        self.dataInputStrategy = dataInputStrategy
    }
}

// Convenience list of available app regions.
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
                dataInputStrategy: .prepopulated(
                    endpoint: URL(string: "https://mock.api/api/nl-user-profile")!
                )
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
