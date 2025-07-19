//
//  CountryData.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct CountryData {
    let name: String
    let flag: Image
    let yamlFileName: String
}

enum Country: CaseIterable {
    case netherlands
    case germany
    case usa

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
        }
    }
}
