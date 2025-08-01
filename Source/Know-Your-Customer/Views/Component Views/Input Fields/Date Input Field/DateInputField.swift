//
//  DatePickerField.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Wraps a button opening a date picker sheet.
struct DateInputField: InputFieldView {
    @Environment(FieldViewModel<Date>.self) var viewModel
    @State private var isFocused = false

    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel

        let textLabel: String = {
            if let date = viewModel.value {
                let formatted = DateFormatterHolder.medium.string(from: date)
                return formatted
            } else {
                return "Select your \(viewModel.config.label)"
            }
        }()

        var textColor: Color {
            guard !viewModel.isReadOnly else {
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
        .dynamicFieldStroke(
            isFocused: isFocused,
            isDisabled: viewModel.isReadOnly,
            isValid: !viewModel.hasErrors,
            padding: 21
        )
        .sheet(isPresented: $isFocused) {
            DateInputFieldSheet(
                fieldLabel: viewModel.config.label,
                selectedDate: $viewModel.value
            )
            .fittedPresentationDetents()
            .presentationDragIndicator(.hidden)
        }
        .onChange(of: viewModel.value) {
            viewModel.validate()
        }
    }

}
