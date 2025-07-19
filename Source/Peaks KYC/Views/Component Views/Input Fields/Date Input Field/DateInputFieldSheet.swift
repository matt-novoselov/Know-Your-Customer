//
//  DateInputFieldSheet.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#warning("Refactor")

struct DateInputFieldSheet: View {
    let fieldLabel: String
    @Binding var selectedDate: Date?
    @Environment(\ .dismiss) private var dismiss
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
        .padding(.top)
        .onAppear {
            tempDate = selectedDate ?? Date()
        }
        
    }
}
