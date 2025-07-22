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

        var isPresented: Binding<Bool> {
            Binding(
                get: { signUpViewModel.isNCPresented },
                set: { signUpViewModel.isNCPresented($0) }
            )
        }

        WelcomeScreenView()
            .fullScreenCover(isPresented: isPresented) {
                SignUpNavigationController()
            }
    }
}
