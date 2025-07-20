//
//  WelcomeScreenView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct WelcomeScreenView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                AppIconView()
                    .frame(height: 44)

                Text("Peaks KYC")
                    .font(.dazzed(style: .largeTitle, weight: .black))
            }

            Text("Verification Made Simple")
                .font(.dazzed(size: 18.5, weight: .medium))
        }
        .padding(.top, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            AnimatedColorsMeshGradientView()
        }
        .bottomGradientOverlay(color: .white, height: 400)
        .overlay(alignment: .bottom) {
            VStack {
                Button("I am new to Peaks") { signUpViewModel.isNCPresented.toggle() }
                    .buttonStyle(.capsule(.brand))

                Button("I already have an account") {}
                    .buttonStyle(.capsule)
                    .disabled(true)
            }
            .padding()
        }
    }
}
