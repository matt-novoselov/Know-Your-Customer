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
    public enum NavigationRoute: Hashable { case countryList, overview, fieldsList, summary }
    
    public private(set) var isNCPresented = false
    public var selectedCountry: Country = .netherlands
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
    
    private var fields: [any AnyFieldViewModel] = []
    private var fieldsViews: [AnyView] = []
    
    /// True only when every field is valid
    private var isValid: Bool {
        fields.allSatisfy { $0.error == nil }
    }
    
    /// Validate all fields at once
    public func validateAll() {
        fields.forEach { $0.validate() }
    }
    
    /// Gather up the final JSON payload
    public func formData() -> [FieldEntry] {
        fields.map { FieldEntry(label: $0.config.label, value: $0.valueAsAny) }
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
    
    public func validateAllFieldsAndSubmit() {
        self.validateAll()
        
        if self.isValid {
            self.navigate(to: .summary)
        }
    }
    
}

#warning("Refactor")
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
