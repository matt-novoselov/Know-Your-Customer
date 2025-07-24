//
//  Protocol.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Required interface for all input field components.
protocol InputFieldView: View {
    associatedtype InputField: View
    associatedtype Value
    var viewModel: FieldViewModel<Value> { get }
    @ViewBuilder func inputFieldView() -> InputField
}

// Provides shared layout for field label, input and error.
extension InputFieldView where Self: View {
    var body: some View {
        let labelText: Text = {
            var text = Text(viewModel.config.label)
            if !viewModel.config.required {
                // swiftlint:disable:next shorthand_operator
                text = text + Text(" (optional)")
            }
            return text
        }()
        let showWarning = viewModel.hasErrors

        return VStack(alignment: .leading) {
            labelText
                .font(.headline)

            inputFieldView()
                .disabled(viewModel.isReadOnly)

            Label(viewModel.error ?? " ", systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .imageScale(.small)
                .opacity(showWarning ? 1 : 0)
                .animation(.spring(duration: 0.2), value: showWarning)
        }
    }
}
