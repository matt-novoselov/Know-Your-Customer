//
//  KYCFlowViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class SignUpViewModel {
    public enum NavigationRoute: Hashable { case countryList, fieldsList, summary }

    public var isSignUpFlowPresented = false
    public var selectedCountry: Country = .netherlands
    public private(set) var selectedConfig: ConfigModel?

    private let configurationLoader: CountryConfigLoaderService
    private let validationService: ValidationService
    private let fieldFactory: FieldFactory

    init() {
        let validationService = ValidationService()
        self.validationService = validationService
        self.fieldFactory = FieldFactory(validationService: validationService)
        self.configurationLoader = CountryConfigLoaderService()
    }

    public func loadConfigForSelectedCountry() async {
        // 1. Load YAML config
        let fileName = selectedCountry.data.yamlFileName
        do {
            selectedConfig = try configurationLoader.loadConfigForSelectedCountry(from: fileName)
        } catch {
            print("Failed loading config for \(selectedCountry):", error)
            return
        }

        // 2. Prepopulate if needed
        var prefilledValues: [FieldEntries] = []
        if case let .prepopulated(endpoint) = selectedCountry.data.behavior {
            let apiService: MockAPIConformable = NLMockAPIService()
            do {
                prefilledValues = try await apiService.fetchUserProfile(from: endpoint.absoluteString).fields
            } catch {
                print("Error fetching prepopulated data:", error)
            }
        }

        // 3. Build fields with (possibly) prefilled values
        loadFields(prefilledValues: prefilledValues)
    }

    public var navigationPath = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.navigationPath.append(route)
    }

    private var fields: [any FieldViewModelProtocol] = []
    private var fieldsViews: [AnyView] = []
    /// Validate all fields at once
    public func validateAll() {
        fields.forEach { $0.validate() }
    }

    /// Gather up the final JSON payload
    public func getSummaryItems() -> [SummaryItem] {
        fields.map { SummaryItem(label: $0.config.label, value: $0.displayValue) }
    }

    private func loadFields(prefilledValues: [FieldEntries]) {
        guard let selectedConfig else { return }
        let result = fieldFactory.makeFields(from: selectedConfig.fields, prefilledValues: prefilledValues)
        self.fields = result.1.compactMap(\.self)
        self.fieldsViews = result.0
    }

    public func getFieldViews() -> [AnyView] {
        self.fieldsViews
    }

    public func getFirstErrorIndex() -> Int? {
        let id = fields.firstIndex(where: { $0.error != nil })
        return id
    }
}
