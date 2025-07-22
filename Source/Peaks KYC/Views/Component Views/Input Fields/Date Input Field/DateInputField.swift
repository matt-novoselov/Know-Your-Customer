//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputField: InputFieldRepresentable {
    @Environment(FieldViewModel<DateComponents>.self) var viewModel
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
        
        let textColor: Color = (viewModel.value == nil ? Color(.placeholderText) : .primary)
        
        Button { isFocused.toggle() } label: {
            HStack {
                Text(textLabel).foregroundColor(textColor)
                Spacer()
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)
            }
        }
        .dynamicFormStroke(isFocused: isFocused, isValid: !viewModel.hasErrors, padding: 21)
        .fittedSizeSheet(isPresented: $isFocused, isDragIndicatorVisible: false) {
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
