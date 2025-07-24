//
//  CountryButtonView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// MARK: CountryButtonView
extension CountryPickerFieldView {
    struct CountryButtonView: View {
            // Button used within the country picker sheet.
        var selectedCountry: SupportedCountry
        var country: SupportedCountry
        var action: () -> Void = {}

        var isInFocus: Bool {
            selectedCountry == country
        }

        var body: some View {
            Button(action: action) {
                CountryLabelView(country: country)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .dynamicStroke(isFocused: isInFocus, style: .roundedRect)
        }
    }
}
