//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Yams
import Foundation

/// Service responsible for loading YAML-based KYC configuration
final class CountryConfigLoaderService {
    enum ServiceError: Error {
        case fileNotFound(name: String)
        case decodingFailed(underlying: Error)
    }

    private let bundle: Bundle
    private let decoder: YAMLDecoder

    init(bundle: Bundle = .main, decoder: YAMLDecoder = .init()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func loadConfigForSelectedCountry(from fileName: String) throws -> ConfigModel {
        guard let url = bundle.url(forResource: fileName, withExtension: nil) else {
            throw ServiceError.fileNotFound(name: fileName)
        }

        do {
            let yamlString = try String(contentsOf: url, encoding: .utf8)
            return try decoder.decode(ConfigModel.self, from: yamlString)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
