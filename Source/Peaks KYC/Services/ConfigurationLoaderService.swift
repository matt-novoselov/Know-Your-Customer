//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Yams
import Foundation

/// Service responsible for loading YAML-based KYC configuration
final class ConfigurationLoaderService {
    enum ServiceError: Error {
        case fileNotFound(name: String)
        case decodingFailed(underlying: Error)
    }

    private let bundle: Bundle
    private let decoder: YAMLDecoder

    /// Initialize service with custom bundle and decoder (for testability)
    init(bundle: Bundle = .main, decoder: YAMLDecoder = YAMLDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func loadConfig(from fileName: String) throws -> ConfigModel {
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
