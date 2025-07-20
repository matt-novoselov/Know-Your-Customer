//
//  DatePickerField.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputField: InputFieldRepresentable {
    @Binding var date: Date?
    var fieldConfig: FieldConfig

    @State private var isPresented = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }

    private var textLabel: String {
        guard let date else {
            return "Select your \(fieldConfig.label)"
        }

        return dateFormatter.string(from: date)
    }

    private var textForegroundColor: Color {
        guard date != nil else {
            return .secondary
        }

        return .primary
    }
    
    @State var validationError: String? = nil

    func inputFieldView() -> some View {
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
        .dynamicStroke(isFocused: isPresented)
        .fittedSizeSheet(isPresented: $isPresented, isDragIndicatorVisible: false) {
            DateInputFieldSheet(fieldLabel: fieldConfig.label, selectedDate: $date)
        }
        .onChange(of: date) {
            self.validationError = self.validateInput(date as Any)
        }
    }
}
