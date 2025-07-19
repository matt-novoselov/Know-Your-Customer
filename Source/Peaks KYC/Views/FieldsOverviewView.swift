//
//  StatusScreenView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct FieldsOverviewView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
#warning("selected config")
    @State private var config: ConfigModel?
    
    var body: some View {
        if let config {
            ScrollView {
                VStack{
                    FieldCompletionStateView(isComplete: true, text: "Select your country")
                    
                    ForEach(config.fields, id: \.id) { field in
                        FieldCompletionStateView(isComplete: false, text: "Fill in \(field.label)")
                    }
                }
                .navigationHeader("This only takes a few steps")
                .padding()
            }
            .bottomGradientOverlay()
            .safeAreaInset(edge: .bottom){
                Button("Continue to the next step") {
                    let nextDestination = SignUpViewModel.NavigationRoute.fieldsList
                    signUpViewModel.path.append(nextDestination)
                }
                .buttonStyle(.capsule)
                .padding()
            }
        } else {
            ProgressView()
                .task {
                    let selectedYAMLFileName = signUpViewModel.selectedCountry.data.yamlFileName
                    config = try? loadKYCConfig(for: selectedYAMLFileName)
                }
        }
    }
}
