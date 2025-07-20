//
//  Protocol.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

protocol InputFieldRepresentable: View {
    associatedtype InputField: View
    var fieldConfig: FieldConfig { get }
    var validationError: String? { get set }
    @ViewBuilder func inputFieldView() -> InputField
}

extension InputFieldRepresentable where Self: View {
    var isReadOnly: Bool { false }

    private var labelText: Text {
        var text = Text(fieldConfig.label)
        if !fieldConfig.required {
            text = text + Text(" (optional)")
        }
        return text
    }

    var isValidationWarningVisible: Bool {
        return self.validationError != nil
    }
    
    func validateInput(_ input: Any) -> String? {
        let service = ValidationService()
        let error = service.validate(field: fieldConfig, value: input)
        return error
    }

    var body: some View {
        VStack(alignment: .leading) {
            labelText
                .font(.headline)

            inputFieldView()
                .disabled(isReadOnly)

            Label(self.validationError ?? " ", systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .imageScale(.small)
                .opacity(isValidationWarningVisible ? 1 : 0)
                .animation(.spring(duration: 0.2), value: self.isValidationWarningVisible)
        }
    }
}
