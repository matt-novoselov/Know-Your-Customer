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
    

    private let configurationLoader = ConfigurationLoaderService()
    public func loadConfig() async {
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfig(from: selectedFileName)
        selectedConfig = configData
        
#warning("handle per country exceptions (NL)")
        
        self.loadFields()
    }
    
    public var path = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.path.append(route)
    }
    
    var fields: [any AnyFormFieldViewModel] = []
    var fieldsViews: [AnyView] = []
    
    /// True only when every field is valid
    var isValid: Bool {
        fields.allSatisfy { $0.error == nil }
    }
    
    /// Validate all fields at once
    func validateAll() {
        fields.forEach { $0.validate() }
    }
    
    /// Gather up the final JSON payload
    func formData() -> [String: Any] {
        Dictionary(uniqueKeysWithValues: fields.map { ($0.config.label, $0.valueAsAny) } )
    }
    
    private func loadFields() {
        guard let selectedConfig else { return }
        let result = FieldFactory.makeFields(from: selectedConfig.fields)
        self.fields = result.1.compactMap(\.self)
        self.fieldsViews = result.0
    }
    
}


struct FieldFactory {
    static func makeFields(from configs: [FieldConfig]) -> ([AnyView],[any AnyFormFieldViewModel]) {
        var fieldViews: [AnyView] = []
        var fieldViewModels: [any AnyFormFieldViewModel] = []
        
        for config in configs {
            switch config.type {
            case .text, .number:
                let vm = FormFieldViewModel<String>(config: config)
                let view = TextInputField().environment(vm)
                fieldViews.append(AnyView(view))
                fieldViewModels.append(vm as (any AnyFormFieldViewModel))
            case .date:
                let vm = FormFieldViewModel<Date?>(config: config)
                let view = DateInputField().environment(vm)
                fieldViews.append(AnyView(view))
                fieldViewModels.append(vm as (any AnyFormFieldViewModel))
            }
        }
        
        return (fieldViews, fieldViewModels)
    }
}
