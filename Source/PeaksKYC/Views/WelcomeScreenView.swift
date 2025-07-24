//
//  WelcomeScreenView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Initial screen showing the app branding and start buttons.
struct WelcomeScreenView: View {
    @Environment(NavigationViewModel.self) private var navigationViewModel

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                AppIconView()
                    .frame(height: 44)
                    .accessibilityHidden(true)

                Text("Peaks KYC")
                    .font(.dazzed(style: .extraLargeTitle, weight: .black))
                    .accessibilityHint("App name")
            }

            Text("Verification Made Simple")
                .font(.dazzed(size: 19, weight: .medium))
                .accessibilityHint("Tagline")
        }
        .padding(.top, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            AnimatedMeshGradientView()
        }
        .gradientOverlay(height: 400)
        .overlay(alignment: .bottom) {
            VStack {
                Button("I am new to Peaks") {
                    navigationViewModel.isViewControllerPresented = true
                }
                .buttonStyle(.capsule(.brand))

                Button("Login") {}
                    .buttonStyle(.capsule)
                    .disabled(true)
            }
            .padding()
        }
    }
}
