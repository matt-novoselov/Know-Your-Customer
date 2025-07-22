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

    public private(set) var isNCPresented = false
    public var selectedCountry: Country = .netherlands
    public private(set) var selectedConfig: ConfigModel?

    private let configurationLoader = ConfigurationLoaderService()
    public func loadConfig() async {
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfig(from: selectedFileName)
        selectedConfig = configData

        self.loadFields()
    }

    public var path = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.path.append(route)
    }

    private var fields: [any AnyFieldViewModel] = []
    private var fieldsViews: [AnyView] = []

    /// Validate all fields at once
    public func validateAll() {
        fields.forEach { $0.validate() }
    }

    /// Gather up the final JSON payload
    public func getResultEntries() -> [ResultEntries] {
        fields.map { ResultEntries(label: $0.config.label, value: $0.displayValue) }
    }

    private func loadFields() {
        guard let selectedConfig else { return }
        let result = FieldFactory.makeFields(from: selectedConfig.fields)
        self.fields = result.1.compactMap(\.self)
        self.fieldsViews = result.0
    }

    public func isNCPresented(_ isPresented: Bool) {
        self.isNCPresented = isPresented
    }

    public func getViews() -> [AnyView] {
        self.fieldsViews
    }

    public func getFirstErrorIndex() -> Int? {
        let id = fields.firstIndex(where: { $0.error != nil })
        return id
    }
}
