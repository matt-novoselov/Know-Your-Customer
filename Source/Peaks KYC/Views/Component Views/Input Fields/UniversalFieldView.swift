//
//  UniversalFieldView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI


struct UniversalFieldView: View {
    @Environment(SignUpViewModel.self) private var signUpViewModel
    let fieldConfig: FieldConfig

    @ViewBuilder
    var body: some View {
        switch fieldConfig.type {
        case .text, .number:
            TextInputField(text: signUpViewModel.binding(for: fieldConfig, default: ""), fieldConfig: fieldConfig)
        case .date:
            DateInputField(date: signUpViewModel.binding(for: fieldConfig, default: nil), fieldConfig: fieldConfig)
        }
    }
}
