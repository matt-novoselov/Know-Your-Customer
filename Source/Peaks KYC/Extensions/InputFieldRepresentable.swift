//
//  Protocol.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

protocol InputFieldRepresentable: View {
    associatedtype InputField: View
    var fieldConfig: FieldConfig { get }
    @ViewBuilder func inputFieldView() -> InputField
}

extension InputFieldRepresentable where Self: View {
    var isValid: Bool { true }
    
    private var labelText: Text {
        var text = Text(fieldConfig.label)
        if !fieldConfig.required {
            text = text + Text(" (optional)")
        }
        return text
    }
    
    private var isValidationWarningVisible: Bool {
        guard fieldConfig.required else { return false }
        return isValid
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            labelText
                .font(.headline)
            
            inputFieldView()
            
            Label(fieldConfig.validation?.message ?? "N/A", systemImage: "exclamationmark.circle.fill")
                .foregroundStyle(.red)
                .imageScale(.small)
                .opacity(isValidationWarningVisible ? 0 : 1)
                .animation(.spring(duration: 0.2), value: self.isValid)
        }
    }
}
