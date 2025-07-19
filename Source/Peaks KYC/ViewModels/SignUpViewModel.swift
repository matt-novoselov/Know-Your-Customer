//
//  KYCFlowViewModel.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class SignUpViewModel {
    public enum NavigationRoute: Hashable { case overview, fieldsList }
    
    var isNCPresented = false
    var selectedCountry: Country = .netherlands
    var path = NavigationPath()
}
