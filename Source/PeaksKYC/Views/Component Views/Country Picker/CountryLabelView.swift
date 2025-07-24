//
//  CountryLabelView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// Displays flag image and localized country name.
extension CountryPickerFieldView {
    struct CountryLabelView: View {
        var country: SupportedCountry

        var body: some View {
            HStack {
                country.data.flag
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .cornerRadius(3)

                Text(country.data.name)
            }
        }
    }
}
