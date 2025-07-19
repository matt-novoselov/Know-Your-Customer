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
            Spacer()
                .frame(height: 50)
            
            HStack {
                AppIconView()
                    .frame(height: 44)
                
                Text("Peaks KYC")
                    .font(.dazzed(style: .largeTitle, weight: .black))
            }
            
            Text("Verification Made Simple")
                .font(.dazzed(style: .headline, weight: .semibold))
            
            Spacer()
            
            Button("I am new to Peaks") { signUpViewModel.isNCPresented.toggle() }
                .buttonStyle(.capsule(.brand))
            
            Button("I already have an account") {}
                .buttonStyle(.capsule)
                .disabled(true)
        }
        .padding()
        .background {
            AnimatedColorsMeshGradientView()
        }
    }
}
