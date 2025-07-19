//
//  HomeView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    
    var body: some View {
        @Bindable var signUpViewModel = signUpViewModel
        
        WelcomeScreenView()
            .fullScreenCover(isPresented: $signUpViewModel.isNCPresented) {
                CountrySelectionView()
            }
    }
}
