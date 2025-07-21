//
//  SignUpNavigationController.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

struct SignUpNavigationController: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel

    var body: some View {
        @Bindable var signUpViewModel = signUpViewModel

        NavigationStack(path: $signUpViewModel.path) {
            CountryListView()
                .signUpNavDestinations()
        }
    }
}

struct SignUpNavDestinationModifier: ViewModifier {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: SignUpViewModel.NavigationRoute.self) { route in
                switch route {
                case .countryList:
                    CountryListView()
                case .overview:
                    FieldsOverviewView()
                case .fieldsList:
                    InputFieldsListView(fieldViews: signUpViewModel.getViews())
                case .summary:
                    SummaryView(fields: signUpViewModel.formData())
                }
            }
    }
}

extension View {
    func signUpNavDestinations() -> some View {
        modifier(SignUpNavDestinationModifier())
    }
}
