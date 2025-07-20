//
//  DateInputFieldSheet.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct DateInputFieldSheet: View {
    @Environment(\ .dismiss) private var dismiss
    let fieldLabel: String
    @Binding var selectedDate: Date?
    @State private var tempDate: Date = Date()
    
    var body: some View {
        VStack {
            ZStack {
                Text(fieldLabel)
                    .font(.dazzed(style: .title1, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Done") {
                    selectedDate = tempDate
                    dismiss()
                }
                .foregroundStyle(.secondary)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            DatePicker(
                "Select your \(fieldLabel)",
                selection: $tempDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
        }
        .padding()
        .padding(.top, 5)
        .onAppear {
            tempDate = selectedDate ?? Date()
        }
    }
}
