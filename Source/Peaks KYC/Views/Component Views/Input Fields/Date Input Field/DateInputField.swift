//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputField: InputFieldRepresentable {
    @Environment(FieldViewModel<Date?>.self) var viewModel
    @State private var isFocused = false
    
    // shared formatter
    private static let sharedFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    func inputFieldView() -> some View {
        @Bindable var viewModel = viewModel
        
        EmptyView()

        let textLabel: String = {
            guard let date = viewModel.value else {
                return "Select your \(viewModel.config.label)"
            }
            return Self.sharedFormatter.string(from: date)
        }()
        
        let textColor: Color = (viewModel.value == nil ? .secondary : .primary)
        
        Button { isFocused.toggle() } label: {
            HStack {
                Text(textLabel).foregroundColor(textColor)
                Spacer()
                Image(systemName: "calendar")
            }
        }
        .dynamicFormStroke(isFocused: isFocused, isValid: !viewModel.hasErrors)
        .fittedSizeSheet(isPresented: $isFocused, isDragIndicatorVisible: false) {
            DateInputFieldSheet(
                fieldLabel: viewModel.config.label,
                selectedDate: $viewModel.value
            )
        }
        .onChange(of: viewModel.value) {
            viewModel.validate()
        }
    }
    
}
