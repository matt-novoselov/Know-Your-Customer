//
//  Protocol.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

protocol InputFieldRepresentable: View {
    associatedtype InputField: View
    associatedtype Value
    var formFieldViewModel: FormFieldViewModel<Value> { get }
    @ViewBuilder func inputFieldView() -> InputField
}

extension InputFieldRepresentable where Self: View {

    private var labelText: Text {
        var text = Text(formFieldViewModel.config.label)
        if !formFieldViewModel.config.required {
            text = text + Text(" (optional)")
        }
        return text
    }

    var isValidationWarningVisible: Bool {
        return self.formFieldViewModel.error != nil
    }

    var body: some View {
        VStack(alignment: .leading) {
            labelText
                .font(.headline)

            inputFieldView()
                .disabled(formFieldViewModel.isReadOnly)

            Label(self.formFieldViewModel.error ?? " ", systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .imageScale(.small)
                .opacity(isValidationWarningVisible ? 1 : 0)
                .animation(.spring(duration: 0.2), value: self.isValidationWarningVisible)
        }
    }
}
