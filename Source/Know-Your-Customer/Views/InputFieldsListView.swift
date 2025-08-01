//
//  InputFieldsListView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Custom modifier to handle unified navigation header on multiple child views.
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

// Shows form fields for the selected country and handles validation.
struct InputFieldsListView: View {
    @Environment(FormViewModel.self) private var formManagerViewModel

    var body: some View {
        Group {
            switch formManagerViewModel.state {
            case .idle, .loading:
                loadingView
            case .loaded(let form):
                ListView(fields: form.fields.map { AnyView($0.view) })
            case .error(let errorMessage):
                ErrorView(errorMessage: errorMessage)
            }
        }
        .task {
            await formManagerViewModel.loadDataForSelectedCountry()
        }
    }

    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .headerModifier()
    }

    private struct ErrorView: View {
        let errorMessage: String
        var body: some View {
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
            .headerModifier()
        }
    }
}

// Presents all form fields and continue button inside a scroll view.
private struct ListView: View {
    @Environment(FormViewModel.self) private var formManagerViewModel
    @Environment(NavigationViewModel.self) private var navigationViewModel
    @Environment(AccessibilityViewModel.self) private var accessibilityViewModel
    let fields: [AnyView]

    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                Group {
                    ForEach(fields.indices, id: \.self) { index in
                        fields[index]
                            .padding(5)
                            .id(index)
                    }

                    Spacer()
                        .frame(height: 100)

                    Button("Continue") {
                        self.verifyInputFields(value: value)
                    }
                    .buttonStyle(.capsule)
                }
                .headerModifier()
            }
        }
    }

    /// Button to verify all fields.
    /// Scrolls to the first error if present.
    /// Navigates to the next screen if all fields are correct.
    private func verifyInputFields(value: ScrollViewProxy) {
        formManagerViewModel.validateAll()

        if let errorId = formManagerViewModel.getFirstErrorIndex() {
            withAnimation {
                value.scrollTo(errorId)
            }

            let message = "There are errors in the form. Please correct the highlighted fields."
            accessibilityViewModel.announce(message)
        } else {
            navigationViewModel.navigate(to: .summary)
        }
    }
}
