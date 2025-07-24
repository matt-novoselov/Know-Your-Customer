//
//  CountryPickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct CountryPickerFieldView: View {
    // Form field allowing the user to choose a country.
    @Binding var selectedCountry: SupportedCountry
    @State var isSheetPresented = false

    var body: some View {
        DropdownCountryButtonView(
            country: selectedCountry,
            action: { isSheetPresented.toggle() },
            isInFocus: isSheetPresented
        )
        .contentFittingSheet(isPresented: $isSheetPresented) {
            countryListSheetView
        }
    }
}
