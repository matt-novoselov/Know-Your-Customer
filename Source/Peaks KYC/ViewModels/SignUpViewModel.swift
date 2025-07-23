//
//  KYCFlowViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#warning("Refactor")
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
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfigForSelectedCountry(from: selectedFileName)
        selectedConfig = configData

        self.loadFields()
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

    private func loadFields() {
        guard let selectedConfig else { return }
        let result = fieldFactory.makeFields(from: selectedConfig.fields)
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
