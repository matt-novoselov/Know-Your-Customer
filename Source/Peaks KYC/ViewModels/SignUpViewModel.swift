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
    
#warning("handle per country exceptions??")
    private let configurationLoader = ConfigurationLoaderService()
    public func loadConfig() async {
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfig(from: selectedFileName)
        selectedConfig = configData
    }

    #warning("validate forms")
    public func isFormValid() -> Bool {
//        guard let fields = selectedConfig?.fields else {
//            return false
//        }
//
//        for field in fields {
//            if field.required ?? false {
//                if store.value(for: field.id) == nil {
//                    return false
//                }
//            }
//        }

        return true
    }
    
    public func getAllStoreValues() -> [String: Any] {
        return store.allValues()
    }

    public var path = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.path.append(route)
    }
}
