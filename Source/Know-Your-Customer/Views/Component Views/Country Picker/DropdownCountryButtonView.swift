//
//  DropdownCountryButtonView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// MARK: DropdownCountryButtonView
extension CountryPickerFieldView {

    // Styled button that toggles the picker sheet.
    struct DropdownCountryButtonView: View {
        var country: SupportedCountry
        var action: () -> Void = {}
        var isInFocus: Bool

        var body: some View {
            Button(action: action) {
                CountryLabelView(country: country)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isInFocus ? 180 : 0))
                            .animation(.spring(duration: 0.3), value: isInFocus)
                    }
            }
            .dynamicStroke(isFocused: isInFocus)
        }
    }

}
