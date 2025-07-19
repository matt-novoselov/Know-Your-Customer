//
//  CountryPickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#warning("Refactor")

struct CountryPickerField: View {
    @Binding var selectedCountry: Country
    @State private var isPresented = false
    
    var body: some View {
        Button {
            isPresented = true
        } label: {
            HStack {
                selectedCountry.data.flag
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32)
                    .cornerRadius(3)
                
                Text(selectedCountry.data.name)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isPresented ? 180 : 0))
                    .animation(.spring(duration: 0.3), value: isPresented)
            }
        }
        .dynamicStroke(isFocused: isPresented)
        .fittedSizeSheet(isPresented: $isPresented) {
            VStack(spacing: 20) {
                Text("Select region")
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(Country.allCases, id: \.self) { country in
                    Button(action: {
                        selectedCountry = country
                        isPresented = false
                    }) {
                        HStack {
                            country.data.flag
                                .resizable()
                                .scaledToFit()
                                .frame(width: 32)
                                .cornerRadius(3)
                            
                            Text(country.data.name)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .dynamicStroke(isFocused: selectedCountry == country, style: .roundedRect)
                    }
                }
            }
            .padding()
            .padding(.top)
        }
        
    }
}

struct CountrySelectionView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    
    var body: some View {
        @Bindable var signUpViewModel = signUpViewModel
        
        NavigationStack(path: $signUpViewModel.path) {
            VStack {
                CountryPickerField(selectedCountry: $signUpViewModel.selectedCountry)
                
                Spacer()
                
                Button("Continue") {
                    let nextDestination = SignUpViewModel.NavigationRoute.overview
                    signUpViewModel.path.append(nextDestination)
                }
                .buttonStyle(.capsule)
            }
            
            .navigationDestination(for: SignUpViewModel.NavigationRoute.self) { route in
                switch route {
                case .overview:
                    FieldsOverviewView()
                case .fieldsList:
                    InputFieldsListView(configs: [])
                }
            }
            
            .navigationHeader("Choose your country")
            
            .padding()
        }
    }
}
