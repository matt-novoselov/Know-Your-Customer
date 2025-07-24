//
//  YAMLConfigLoader.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import Yams
import Foundation

/// Service responsible for loading YAML-based KYC configuration
final class YAMLFileDecoder {
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

    func load<T: Decodable>(_ type: T.Type, from fileName: String) throws -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: nil) else {
            throw ServiceError.fileNotFound(name: fileName)
        }

        do {
            let yamlString = try String(contentsOf: url, encoding: .utf8)
            return try decoder.decode(T.self, from: yamlString)
        } catch {
            throw ServiceError.decodingFailed(underlying: error)
        }
    }
}
