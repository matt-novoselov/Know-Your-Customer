//
//  UniversalFieldView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

#warning("Remove constants, make fields savable")

struct UniversalFieldView: View {
    let fieldConfig: FieldConfig

    @ViewBuilder
    var body: some View {
        switch fieldConfig.type {
        case .text, .number:
            TextInputField(text: .constant(""), fieldConfig: fieldConfig)
        case .date:
            DateInputField(date: .constant(nil), fieldConfig: fieldConfig)
        }
    }
}
