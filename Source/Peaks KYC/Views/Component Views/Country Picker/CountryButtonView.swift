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
        var selectedCountry: Country
        var country: Country
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
