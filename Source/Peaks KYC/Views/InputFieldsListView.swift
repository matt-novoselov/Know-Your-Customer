//
//  InputFieldsListView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct InputFieldsListView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    let fieldViews: [AnyView]
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(fieldViews.indices, id: \.self) { index in
                    fieldViews[index]
                        .padding(5)
                }
                
                Spacer()
                    .frame(height: 100)
                
                Button("Continue") {
                    signUpViewModel.validateAllFieldsAndSubmit()
                }
                .buttonStyle(.capsule)
            }
            .navigationHeader("Personal Details")
            .padding()
        }
    }
}
