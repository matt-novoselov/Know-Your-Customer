//
//  CountryPickerFieldView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// Sheet presenting available countries for selection.
extension CountryPickerFieldView {
    var countryListSheetView: some View {
        VStack(spacing: 20) {
            Text("Select region")
                .font(.dazzed(style: .title1, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)

            ForEach(SupportedCountry.allCases, id: \.self) { country in
                CountryButtonView(
                    selectedCountry: selectedCountry,
                    country: country,
                    action: {
                        selectedCountry = country
                        isSheetPresented = false
                    }
                )
            }
        }
        .padding()
        .padding(.top)
    }
}
