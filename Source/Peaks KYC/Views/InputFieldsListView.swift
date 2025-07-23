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
        Group {
            if signUpViewModel.selectedConfig != nil {
                ListView(fieldViews: signUpViewModel.getFieldViews())
            } else {
                ProgressView()
            }
        }
        .task {
            await signUpViewModel.loadConfigForSelectedCountry()
        }
    }

    #warning("refactor")
    private struct ListView: View {
        @Environment(SignUpViewModel.self) private var signUpViewModel
        let fieldViews: [AnyView]

        var body: some View {
            ScrollViewReader { value in
                ScrollView {
                    Group {
                        ForEach(fieldViews.indices, id: \.self) { index in
                            fieldViews[index]
                                .padding(5)
                                .id(index)
                        }

                        Spacer()
                            .frame(height: 100)

                        Button("Continue") {
                            signUpViewModel.validateAll()

                            if let errorId = signUpViewModel.getFirstErrorIndex() {
                                withAnimation {
                                    value.scrollTo(errorId)
                                }
                            } else {
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
    }
}
