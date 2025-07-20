//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct FieldCompletionStateView: View {
    let isComplete: Bool
    let text: String

    var body: some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "clock")
                .foregroundStyle(isComplete ? .green : .secondary)

            Text(text)
                .foregroundStyle(isComplete ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .dynamicStroke(isFocused: false, style: .roundedRect)
    }
}
