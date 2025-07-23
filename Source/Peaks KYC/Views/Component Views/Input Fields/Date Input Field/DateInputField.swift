//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputField: InputFieldView {
    @Environment(FieldViewModel<DateComponents>.self) var viewModel
    @Environment(\.isEnabled) private var isEnabled
    @State private var isFocused = false

    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel

        let textLabel: String = {
            if let formatted = viewModel.sharedFormatter.string(from: viewModel.value) {
                return formatted
            } else {
                return "Select your \(viewModel.config.label)"
            }
        }()

        var textColor: Color {
            guard isEnabled else {
                return .secondary
            }
            if viewModel.value == nil {
                return Color(.placeholderText)
            } else {
                return .primary
            }
        }

        Button { isFocused.toggle() } label: {
            HStack {
                Text(textLabel)
                    .foregroundColor(textColor)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
            }
        }
        .dynamicFieldStroke(isFocused: isFocused, isDisabled: !isEnabled, isValid: !viewModel.hasErrors, padding: 21)
        .contentFittingSheet(isPresented: $isFocused, isDragIndicatorVisible: false) {
            DateInputFieldSheet(
                fieldLabel: viewModel.config.label,
                selectedComponents: $viewModel.value
            )
        }
        .onChange(of: viewModel.value) {
            viewModel.validate()
        }
    }

}
