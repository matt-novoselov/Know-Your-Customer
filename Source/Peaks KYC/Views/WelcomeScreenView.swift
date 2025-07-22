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
                    .font(.dazzed(style: .extraLargeTitle, weight: .black))
            }
            
            Text("Verification Made Simple")
                .font(.dazzed(size: 19, weight: .medium))
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
                    signUpViewModel.isNCPresented(true)
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
