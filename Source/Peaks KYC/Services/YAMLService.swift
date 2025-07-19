//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//


import Yams
import Foundation

#warning("Refactor")

func loadKYCConfig(for fileName: String) throws -> ConfigModel {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
        throw NSError(domain: "YAML", code: 1, userInfo: [NSLocalizedDescriptionKey: "\(fileName) not found"])
    }
    let yamlString = try String(contentsOf: url, encoding: .utf8)
    let decoder = YAMLDecoder()
    return try decoder.decode(ConfigModel.self, from: yamlString)
}
