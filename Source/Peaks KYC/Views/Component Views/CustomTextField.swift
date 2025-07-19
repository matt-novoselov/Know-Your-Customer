//
//  SwiftUIView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct MyTextField: DataFieldProtocol {
    @State private var text = ""
    let fieldConfig: FieldConfig

    func inputField() -> some View {
        TextField(
            fieldConfig.label,
            text: $text,
            prompt: Text("Enter \(fieldConfig.label.lowercased())")
        )
        .keyboardType(.default)
        .textFieldStyle(PeaksTextFieldStyle(text: $text, isValid: isValid))
    }
}

struct FieldWrapper: View {
    let fieldConfig: FieldConfig

    @ViewBuilder
    var body: some View {
        switch fieldConfig.type {
        case .text, .number:
            MyTextField(fieldConfig: fieldConfig)
        case .date:
            DatePickerField(fieldConfig: fieldConfig)
        }
    }
}

    import Yams

struct FieldFormView: View {
    let configs: [FieldConfig]
    @Binding var path: NavigationPath

    var body: some View {
        ScrollView {
            Group {
                ForEach(configs, id: \.id) { cfg in
                    FieldWrapper(fieldConfig: cfg)
                        .padding(.vertical, 5)
                }

                Spacer()
                    .frame(height: 100)

                Button("Continue") {

                }
                .buttonStyle(PeaksButtonStyle())
                .disabled(true)
            }
            .withHeader("Personal Details")
            .padding()

        }
    }
}
