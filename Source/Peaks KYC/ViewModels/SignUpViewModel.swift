//
//  KYCFlowViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class SignUpViewModel {
    public enum NavigationRoute: Hashable { case countryList, overview, fieldsList }

    var isNCPresented = false
    var selectedCountry: Country = .netherlands
    public private(set) var selectedConfig: ConfigModel?

    private let configurationLoader = ConfigurationLoaderService()
    public func loadConfig() async {
        let selectedFileName = selectedCountry.data.yamlFileName
        let configData = try? configurationLoader.loadConfig(from: selectedFileName)
        selectedConfig = configData
    }

    public var path = NavigationPath()
    public func navigate(to route: NavigationRoute) {
        self.path.append(route)
    }
}
