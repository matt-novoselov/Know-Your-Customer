//
//  CountryLabelView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

// MARK: CountryLabelView
extension CountryPickerFieldView {
    struct CountryLabelView: View {
        var country: Country
        
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
