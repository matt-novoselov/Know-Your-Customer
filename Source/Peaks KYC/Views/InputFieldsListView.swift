//
//  InputFieldsListView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct InputFieldsListView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    private let fieldFactory = FieldFactory()
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(Array(signUpViewModel.fieldsViews.enumerated()), id: \.offset) { _, field in
                    field
                        .padding(5)
                }
                
                Spacer()
                    .frame(height: 100)
                
                Button("Continue") {
                    // 1.
                    signUpViewModel.validateAll()
                    
                    if signUpViewModel.isValid {
                        signUpViewModel.navigate(to: .summary)
                    }
                }
                .buttonStyle(.capsule)
            }
            .navigationHeader("Personal Details")
            .padding()
        }
    }
}
