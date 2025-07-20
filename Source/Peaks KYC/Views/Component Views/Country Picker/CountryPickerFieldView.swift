//
//  CountryPickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct CountryPickerFieldView: View {
    @Binding var selectedCountry: Country
    @State private var isSheetPresented = false
    
    var body: some View {
        DropdownCountryButtonView(
            country: selectedCountry,
            action: { isSheetPresented.toggle() },
            isInFocus: isSheetPresented
        )
        .fittedSizeSheet(isPresented: $isSheetPresented) {
            sheetView
        }
    }
}

// MARK: CountryLabelView
extension CountryPickerFieldView {
    private struct CountryLabelView: View {
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

// MARK: CountryButtonView
extension CountryPickerFieldView {
    private struct CountryButtonView: View {
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

// MARK: DropdownCountryButtonView
extension CountryPickerFieldView {
    private struct DropdownCountryButtonView: View {
        var country: Country
        var action: () -> Void = {}
        var isInFocus: Bool
        
        var body: some View {
            Button(action: action) {
                CountryLabelView(country: country)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .trailing){
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees(isInFocus ? 180 : 0))
                            .animation(.spring(duration: 0.3), value: isInFocus)
                    }
            }
            .dynamicStroke(isFocused: isInFocus)
        }
    }
}

// MARK: SheetView
extension CountryPickerFieldView {
    private var sheetView: some View {
        VStack(spacing: 20) {
            Text("Select region")
                .font(.dazzed(style: .title1, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(Country.allCases, id: \.self) { country in
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
