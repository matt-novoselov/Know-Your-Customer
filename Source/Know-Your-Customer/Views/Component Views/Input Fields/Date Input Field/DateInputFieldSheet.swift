//
//  DateInputFieldSheet.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Sheet used to pick and save a calendar date.
struct DateInputFieldSheet: View {
    @Environment(\.dismiss) private var dismiss
    let fieldLabel: String
    @Binding var selectedDate: Date?
    @State private var tempDate: Date = Date().yearMonthDay

    var body: some View {
        VStack {
            ZStack {
                Text(fieldLabel)
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button("Clear") {
                    selectedDate = nil
                    dismiss()
                }
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            let dateBinding = Binding<Date>(
                get: {
                    tempDate
                },
                set: { newDate in
                    tempDate = newDate.yearMonthDay
                }
            )

            DatePicker(
                "Select your \(fieldLabel)",
                selection: dateBinding,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)

            Button("Save") {
                selectedDate = tempDate
                dismiss()
            }
            .buttonStyle(.capsule)
        }
        .padding()
        .padding(.top, 5)
        .onAppear {
            if let existing = selectedDate {
                tempDate = existing
            }
        }
    }
}
