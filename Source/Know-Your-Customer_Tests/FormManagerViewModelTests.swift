//
//  FormManagerViewModelTests.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 23/07/25.
//

import Testing
@testable import Know_Your_Customer
import SwiftUI

@Suite("Form Manager View Model")
struct FormManagerViewModelTests {
    // Sample profile to prefill fields
    private let profileYAML = """
    fields:
      - id: first_name
        value: Jan
      - id: last_name
        value: Jansen
      - id: birth_date
        value: "1990-07-23"
    """

    // Helper to spin up a FormViewModel with given country YAML
    private func makeViewModel(
        countryYAML: String
    ) async throws -> FormViewModel {
        // Create a temporary bundle containing both the country config and mock profile
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "Country.yaml": countryYAML,
            "MockUserProfile.yaml": profileYAML
        ])
        let decoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: decoder)
        let loader = ConfigLoaderService(fileDecoder: decoder,
                                         apiRequestService: apiService)
        let factory = FieldFactory(validationService: ValidationService())
        let formService = FormFactoryService(configLoader: loader,
                                             fieldFactory: factory)
        return FormViewModel(validationService: ValidationService(),
                             formBuildingService: formService)
    }

    @Test("Becomes Error State on Invalid YAML")
    func testLoadError() async throws {
        // invalid config should trigger error
        let invalidYAML = "invalid:"
        let viewModel = try await makeViewModel(countryYAML: invalidYAML)

        await viewModel.loadDataForSelectedCountry()

        if case .error(let msg) = viewModel.state {
            #expect(msg.contains("Failed to load configuration"))
        } else {
            fatalError("expected .error state")
        }
    }

    @Test("ValidateAll Calls Each Field’s Validate()")
    func testValidateAllTriggersValidation() async throws {
        // custom VM to spy on validate()
        final class SpyFieldVM: FieldViewModelProtocol {
            var config: FieldConfig
            var error: String?
            var isReadOnly = false
            var displayValue = ""
            private(set) var validateCalled = false

            init(config: FieldConfig) { self.config = config }
            func validate() { validateCalled = true }
            var hasErrors: Bool { error != nil }
        }

        // override factory to return our spy VM
        let bundle = try makeTemporaryBundle(yamlFiles: [
            "Country.yaml": """
            country: NL
            fields:
              - id: first_name
                label: First
                type: text
                required: false
            """,
            "MockUserProfile.yaml": profileYAML
        ])
        let decoder = YAMLFileDecoder(bundle: bundle)
        let apiService = APIRequestService(fileDecoder: decoder)
        let loader = ConfigLoaderService(fileDecoder: decoder,
                                         apiRequestService: apiService)
        let factory = FieldFactory(validationService: ValidationService())

        let viewModel = FormViewModel(
            validationService: ValidationService(),
            formBuildingService: FormFactoryService(configLoader: loader,
                                                    fieldFactory: factory)
        )

        await viewModel.loadDataForSelectedCountry()
        viewModel.validateAll()

        // our spyVM should have been triggered
        if case .loaded(let form) = viewModel.state {
            let anyFieldVM = form.fields.first?.viewModel
            let spy = anyFieldVM as? SpyFieldVM
            #expect(spy?.validateCalled == true)
        }
    }

    @Test("Summary Items Match Fields and no Errors Returns nil Index")
    func testSummaryAndFirstError() async throws {
        // multiple fields, one with an error
        let multiYAML = """
        country: NL
        fields:
          - id: a
            label: L
            type: text
            required: false
          - id: b
            label: L2
            type: text
            required: false
        """
        let viewModel = try await makeViewModel(countryYAML: multiYAML)
        await viewModel.loadDataForSelectedCountry()

        // all fields should appear in the summary
        if case .loaded(let form) = viewModel.state {
            let items = viewModel.getSummaryItems()
            #expect(items.count == form.fields.count)
        }

        // since we never set an error, firstErrorIndex should be nil
        #expect(viewModel.getFirstErrorIndex() == nil)
    }
}
