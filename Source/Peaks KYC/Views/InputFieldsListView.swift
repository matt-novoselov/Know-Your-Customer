//
//  InputFieldsListView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

private struct HeaderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationHeader("Personal Details")
            .padding()
    }
}

private extension View {
    func headerModifier() -> some View {
        modifier(HeaderModifier())
    }
}

struct InputFieldsListView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    @State private var fieldViews: [AnyView]?

    var body: some View {
        Group {
            if let views = fieldViews {
                ListView(fieldViews: views)
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .headerModifier()
            }
        }
        .task {
            self.fieldViews = await signUpViewModel.loadConfigForSelectedCountry()
        }
    }

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
                    .headerModifier()
                }
            }
        }
    }
}
