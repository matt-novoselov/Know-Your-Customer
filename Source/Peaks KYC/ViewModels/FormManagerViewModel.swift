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
            let result = try await configLoader.loadData(for: selectedCountry)
            let fields = fieldFactory.makeFields(
                from: result.config.fields,
                prefilledValues: result.prefilledValues
            )
            state = .loaded(fields)
        } catch {
            state = .error("Failed to load configuration: \(error.localizedDescription)")
        }
    }

    func validateAll() {
        if case .loaded(let fields) = state {
            fields.forEach { $0.viewModel.validate() }
        }
    }

    func getSummaryItems() -> [SummaryView.Entry] {
        if case .loaded(let fields) = state {
            return fields.map { SummaryView.Entry(label: $0.viewModel.config.label, value: $0.viewModel.displayValue) }
        }
        return []
    }

    func getFirstErrorIndex() -> Int? {
        if case .loaded(let fields) = state {
            return fields.firstIndex(where: { $0.viewModel.error != nil })
        }
        return nil
    }
}

extension FormManagerViewModel {
    enum State {
        case idle
        case loading
        case loaded([FormField])
        case error(String)
    }
}
