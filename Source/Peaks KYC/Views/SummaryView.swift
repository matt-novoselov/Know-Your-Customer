
//
//  SummaryView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/24.
//

import SwiftUI

#warning("FieldEntry")
struct FieldEntry: Identifiable {
    let id = UUID()
    let label: String
    let value: Any
}

#warning("Make view display N/A, not nil ot EmptyString")
// A view to display the summary of collected user data
struct SummaryView: View {
    let fields:  [FieldEntry]
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(fields) { field in
                    FieldSummary(label: field.label, value: (String(describing: field.value)))
                }
            }
            .navigationHeader("Collected Information")
            .padding()
        }
    }
    
    private struct FieldSummary: View {
        let label: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                Text(label)
                    .font(.dazzed(style: .title3, weight: .bold))
                
                Text(value)
                    .font(.dazzed(style: .body, weight: .medium))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .dynamicStroke(isFocused: false, style: .roundedRect)
        }
    }
}
