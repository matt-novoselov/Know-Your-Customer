//
//  CountryData.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#if targetEnvironment(simulator)
private let isDebugging = true
#else
private let isDebugging = false
#endif

struct CountryData {
    let name: String
    let flag: Image
    let yamlFileName: String
}

enum Country {
    case netherlands
    case germany
    case usa
    case debug

    var data: CountryData {
        switch self {
        case .netherlands:
            return CountryData(
                name: "The Netherlands",
                flag: Image(.netherlandsFlag),
                yamlFileName: "NL.yaml"
            )
        case .germany:
            return CountryData(
                name: "Germany",
                flag: Image(.germanyFlag),
                yamlFileName: "DE.yaml"
            )
        case .usa:
            return CountryData(
                name: "United States of America",
                flag: Image(.usaFlag),
                yamlFileName: "US.yaml"
            )
        case .debug:
            return CountryData(
                name: "Debug Country",
                flag: Image(.pirateFlag),
                yamlFileName: "DEBUG.yaml"
            )
        }
    }
}

extension Country: CaseIterable {
    static var allCases: [Country] {
        var base: [Country] = [.netherlands, .germany, .usa]
        if isDebugging {
            base.append(.debug)
        }
        return base
    }
}
