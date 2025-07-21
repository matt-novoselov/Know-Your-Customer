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
    
    var fields: [any AnyFieldViewModel] = []
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
    func formData() -> [FieldEntry] {
        fields.map { FieldEntry(label: $0.config.label, value: $0.valueAsAny) }
    }
    
    private func loadFields() {
        guard let selectedConfig else { return }
        let result = FieldFactory.makeFields(from: selectedConfig.fields)
        self.fields = result.1.compactMap(\.self)
        self.fieldsViews = result.0
    }
    
}


struct FieldFactory {
    static func makeFields(from configs: [FieldConfig]) -> ([AnyView],[any AnyFieldViewModel]) {
        var fieldViews: [AnyView] = []
        var fieldViewModels: [any AnyFieldViewModel] = []
        
        for config in configs {
            switch config.type {
            case .text, .number:
                let vm = FieldViewModel<String>(config: config)
                let view = TextInputField().environment(vm)
                fieldViews.append(AnyView(view))
                fieldViewModels.append(vm as (any AnyFieldViewModel))
            case .date:
                let vm = FieldViewModel<Date?>(config: config)
                let view = DateInputField().environment(vm)
                fieldViews.append(AnyView(view))
                fieldViewModels.append(vm as (any AnyFieldViewModel))
            }
        }
        
        return (fieldViews, fieldViewModels)
    }
}
