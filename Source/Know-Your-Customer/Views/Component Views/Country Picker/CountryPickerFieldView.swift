//
//  CountryPickerField.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Form field allowing the user to choose a country.
struct CountryPickerFieldView: View {
    @Binding var selectedCountry: SupportedCountry
    @State var isSheetPresented = false

    var body: some View {
        DropdownCountryButtonView(
            country: selectedCountry,
            action: { isSheetPresented.toggle() },
            isInFocus: isSheetPresented
        )
        .sheet(isPresented: $isSheetPresented) {
            countryListSheetView
                .fittedPresentationDetents()
                .presentationDragIndicator(.visible)
        }
    }
}
