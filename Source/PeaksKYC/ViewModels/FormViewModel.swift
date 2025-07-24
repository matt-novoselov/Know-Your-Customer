//
//  FieldsManagerViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class FormViewModel {
    // Manages form state and orchestrates validation.
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

    // Loads Field Views / View Model based on the selected country.
    func loadDataForSelectedCountry() async {
        // Do not load country again if it is already selected
        if case .loaded(let form) = state, form.country == selectedCountry {
            return
        }

        state = .loading

        do {
            let fields = try await formBuildingService.buildForm(for: selectedCountry)
            state = .loaded(fields)
        } catch {
            state = .error("Failed to load configuration: \(error.localizedDescription)")
        }
    }

    // Validates all form's fields.
    func validateAll() {
        if case .loaded(let form) = state {
            form.fields.forEach { $0.viewModel.validate() }
        }
    }

    // Collects user input from all of the fields.
    func getSummaryItems() -> [SummaryView.Entry] {
        if case .loaded(let form) = state {
            return form.fields.map {
                SummaryView.Entry(
                    label: $0.viewModel.config.label,
                    value: $0.viewModel.displayValue
                )
            }
        }
        return []
    }

    // Returns index of the first incorrect field.
    // Used in the ScrollView
    func getFirstErrorIndex() -> Int? {
        if case .loaded(let form) = state {
            return form.fields.firstIndex(where: { $0.viewModel.error != nil })
        }
        return nil
    }
}

extension FormViewModel {
    enum State {
        case idle
        case loading
        case loaded(LoadedForm)
        case error(String)
    }
}
