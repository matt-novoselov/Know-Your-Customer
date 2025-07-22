//
//  StatusScreenView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#warning("FieldsOverviewView")
struct FieldsOverviewView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel

    var body: some View {
        Group {
            if let config = signUpViewModel.selectedConfig {
                ListView(config: config)
            } else {
                ProgressView()
            }
        }
        .task {
            await signUpViewModel.loadConfig()
        }
    }

    private struct ListView: View {
        @Environment(SignUpViewModel.self) private var signUpViewModel
        let config: ConfigModel

        var body: some View {
            ScrollView {
                VStack {
                    FieldCompletionStateView(isComplete: true, text: "Select your country")

                    ForEach(config.fields) { field in
                        FieldCompletionStateView(isComplete: false, text: "Fill in \(field.label)")
                    }
                }
                .navigationHeader("This only takes a few steps")
                .padding()
            }
            .gradientOverlay()
            .safeAreaInset(edge: .bottom) {
                Button("Continue to the next step") {
                    signUpViewModel.navigate(to: .fieldsList)
                }
                .buttonStyle(.capsule)
                .padding()
            }
        }
    }
}
