//
//  InputFieldsListView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct InputFieldsListView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel

    var body: some View {
        ScrollView {
            Group {
                if let configs = signUpViewModel.selectedConfig?.fields {
                    ForEach(configs, id: \.id) { cfg in
                        UniversalFieldView(fieldConfig: cfg)
                            .padding(.vertical, 5)
                    }
                }

                Spacer()
                    .frame(height: 100)

                Button("Continue") {
//                    signUpViewModel.navigate(to: .summary)
                    let errors = signUpViewModel.validateAllFields()
                    print(dump(errors))
                }
                .buttonStyle(.capsule)
//                .disabled()
                #warning("Check all fields for requirements and disable")
            }
            .navigationHeader("Personal Details")
            .padding()
        }
    }
}
