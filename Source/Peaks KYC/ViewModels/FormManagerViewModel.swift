//
//  FieldsManagerViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class FormManagerViewModel {
    var selectedCountry: Country = .netherlands
    private(set) var state: State = .idle
    private let configLoader: ConfigLoaderService
    private let validationService: ValidationService
    private let fieldFactory: FieldFactory

    init() {
        self.configLoader = .init()
        self.validationService = .init()
        self.fieldFactory = .init(validationService: validationService)
    }

    func loadDataForSelectedCountry() async {
        state = .loading

        do {
            let (config, prefilledValues) = try await configLoader.loadData(for: selectedCountry)
            let fields = fieldFactory.makeFields(
                from: config.fields,
                prefilledValues: prefilledValues
            )
            state = .loaded(fields)
        } catch {
            state = .error("Failed to load configuration: \(error.localizedDescription)")
        }
    }

    #warning("remove tuple")
    func validateAll() {
        if case .loaded(let fields) = state {
            fields.1.forEach { $0.validate() }
        }
    }

    func getSummaryItems() -> [SummaryView.Entry] {
        if case .loaded(let fields) = state {
            return fields.1.map { SummaryView.Entry(label: $0.config.label, value: $0.displayValue) }
        }
        return []
    }

    func getFirstErrorIndex() -> Int? {
        if case .loaded(let fields) = state {
            return fields.1.firstIndex(where: { $0.error != nil })
        }
        return nil
    }
}

extension FormManagerViewModel {
    enum State {
        case idle
        case loading
        case loaded(([AnyView], [any FieldViewModelProtocol]))
        case error(String)
    }
}
