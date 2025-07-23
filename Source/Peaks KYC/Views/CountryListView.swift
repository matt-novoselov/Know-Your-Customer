//
//  CountrySelectionView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 20/07/25.
//

import SwiftUI

struct CountryListView: View {
    @Environment(FormManagerViewModel.self) private var formManagerViewModel
    @Environment(NavigationViewModel.self) private var navigationViewModel

    var body: some View {
        @Bindable var formManagerViewModel = formManagerViewModel

        VStack {
            CountryPickerFieldView(selectedCountry: $formManagerViewModel.selectedCountry)

            Spacer()

            Button("Continue") {
                navigationViewModel.navigate(to: .fieldsList)
            }
            .buttonStyle(.capsule)
        }
        .navigationHeader("Choose your country")
        .padding()
    }
}
