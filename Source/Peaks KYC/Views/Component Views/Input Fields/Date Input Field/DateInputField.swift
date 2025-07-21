//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputField: InputFieldRepresentable {
    @Environment(FormFieldViewModel<Date?>.self) var formFieldViewModel
    @State private var isPresented = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var textLabel: String {
        guard let date = formFieldViewModel.value else {
            return "Select your \(formFieldViewModel.config.label)"
        }
        
        return dateFormatter.string(from: date)
    }
    
    private var textForegroundColor: Color {
        guard formFieldViewModel.value != nil else {
            return .secondary
        }
        
        return .primary
    }
    
    
    var focusColor: Color {
        let hasError = formFieldViewModel.error != nil

        // error state takes precedence
        if hasError {
            return .red
        }

        return .primary
    }

    
    var isFieldFocused: Bool {
        let isValid = formFieldViewModel.error == nil
        return isPresented || !isValid
    }
    
    func inputFieldView() -> some View {
        @Bindable var formFieldViewModel = formFieldViewModel
        
        Button {
            isPresented.toggle()
        } label: {
            HStack {
                Text(textLabel)
                    .foregroundColor(textForegroundColor)
                Spacer()
                Image(systemName: "calendar")
            }
        }
        .dynamicStroke(isFocused: isFieldFocused, focusColor: focusColor)
        .fittedSizeSheet(isPresented: $isPresented, isDragIndicatorVisible: false) {
            DateInputFieldSheet(fieldLabel: formFieldViewModel.config.label, selectedDate: $formFieldViewModel.value)
        }
        .onChange(of: formFieldViewModel.value) {
            formFieldViewModel.validate()
        }
    }
}
