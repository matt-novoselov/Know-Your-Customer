
//
//  SummaryView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 18/07/24.
//

import SwiftUI

// A view to display the summary of collected user data
struct SummaryView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    
    var body: some View {
        ScrollView {
            Group {
                if let selectedConfig = signUpViewModel.selectedConfig {
                    let entries = signUpViewModel
                        .formData()
                        .map { (key: $0.key, value: "\($0.value)") }

                    ForEach(entries, id: \.key) { entry in
                        FieldSummary(label: entry.key, value: entry.value)
                    }

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
