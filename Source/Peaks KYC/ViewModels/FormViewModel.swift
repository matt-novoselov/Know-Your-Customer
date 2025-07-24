//
//  FieldsManagerViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class FormViewModel {
    var selectedCountry: SupportedCountry = .netherlands
    private(set) var state: State = .idle
    private let validationService: ValidationService
    private let formBuildingService: FormFactoryService

    init(
        validationService: ValidationService,
        formBuildingService: FormFactoryService
    ) {
        self.validationService = validationService
        self.formBuildingService = formBuildingService
    }

    func loadDataForSelectedCountry() async {
        state = .loading

        do {
            let fields = try await formBuildingService.buildForm(for: selectedCountry)
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

extension FormViewModel {
    enum State {
        case idle
        case loading
        case loaded([FormField])
        case error(String)
    }
}
