//
//  CountrySelectionView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

struct CountryListView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel

    var body: some View {
        @Bindable var signUpViewModel = signUpViewModel

        VStack {
            CountryPickerFieldView(selectedCountry: $signUpViewModel.selectedCountry)

            Spacer()

            Button("Continue") {
                signUpViewModel.navigate(to: .overview)
            }
            .buttonStyle(.capsule)
        }
        .navigationHeader("Choose your country")
        .padding()
    }
}
