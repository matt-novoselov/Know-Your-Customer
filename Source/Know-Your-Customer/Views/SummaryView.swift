//
//  SummaryView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 18/07/24.
//

import SwiftUI

// A view to display the summary of collected user data
struct SummaryView: View {
    // Displays a list of all entered values for review.
    let entries: [Entry]

    var body: some View {
        ScrollView {
            Group {
                ForEach(entries) { entry in
                    FieldSummary(label: entry.label, value: entry.value)
                }
            }
            .navigationHeader("Collected Data")
            .padding()
        }
    }

    // Displays a single label/value pair.
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

extension SummaryView {
    struct Entry: Identifiable {
        var id = UUID()
        var label: String
        var value: String
    }
}
