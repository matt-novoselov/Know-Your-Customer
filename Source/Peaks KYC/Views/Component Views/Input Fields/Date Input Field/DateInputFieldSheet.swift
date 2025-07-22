//
//  DateInputFieldSheet.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputFieldSheet: View {
    @Environment(\.dismiss) private var dismiss
    let fieldLabel: String
    @Binding var selectedComponents: DateComponents?
    @State private var tempComponents: DateComponents =
    Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    var body: some View {
        VStack {
            ZStack {
                Text(fieldLabel)
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Clear") {
                    selectedComponents = nil
                    dismiss()
                }
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            let dateBinding = Binding<Date>(
                get: {
                    Calendar.current.date(from: tempComponents)!
                },
                set: { newDate in
                    tempComponents = Calendar.current.dateComponents([.year, .month, .day], from: newDate)
                }
            )
            
            DatePicker(
                "Select your \(fieldLabel)",
                selection: dateBinding,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            
            Button("Save"){
                selectedComponents = tempComponents
                dismiss()
            }
            .buttonStyle(.capsule)
        }
        .padding()
        .padding(.top, 5)
        .onAppear {
            if let existing = selectedComponents {
                tempComponents = existing
            }
        }
    }
}
