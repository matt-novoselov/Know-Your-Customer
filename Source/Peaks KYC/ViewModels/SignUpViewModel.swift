//
//  KYCFlowViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class SignUpViewModel {
    public enum NavigationRoute: Hashable { case countryList, overview, fieldsList, summary }

    var isNCPresented = false
    var selectedCountry: Country = .netherlands
    public private(set) var selectedConfig: ConfigModel?
    private let store = UserFormDataStore()
    
    func binding<Value>(
        for field: FieldConfig,
        default defaultValue: Value
    ) -> Binding<Value> {
        Binding<Value>(
            get: {
                (self.store.value(for: field.id) as? Value) ?? defaultValue
            },
            set: { new in
                self.store.setValue(new, for: field.id)
            }
        )
    }
    
    #warning("handle per country exceptions (NL)")
    private let configurationLoader = ConfigurationLoaderService()
    public func loadConfig() async {
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfig(from: selectedFileName)
        selectedConfig = configData
    }
    
    public func getAllStoreValues() -> [String: Any] {
        return store.allValues()
    }
    
    public func validateAllFields() -> [String: String] {
        let validationService = ValidationService()
        let allValues = self.getAllStoreValues()
        guard let configFields = selectedConfig?.fields else { return [:] }
        return validationService.validate(fields: configFields, values: allValues)
    }

    public var path = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.path.append(route)
    }
}
