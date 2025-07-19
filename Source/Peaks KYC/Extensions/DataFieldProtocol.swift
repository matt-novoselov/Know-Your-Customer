//
//  Protocol.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

protocol DataFieldProtocol: View {
  associatedtype InputField: View
  var fieldConfig: FieldConfig { get }
  @ViewBuilder func inputField() -> InputField
}


extension DataFieldProtocol where Self: View {
    var isValid: Bool { false }
  var body: some View {
    VStack(alignment: .leading) {
        Text("\(fieldConfig.label)\(!fieldConfig.required ? " (optional)" : "")")
        .font(.headline)

      inputField()

        Label(fieldConfig.validation?.message ?? "N/A", systemImage: "exclamationmark.circle.fill")
        .foregroundStyle(.red)
        .imageScale(.small)
        .opacity(self.isValid ? 0 : 1)
        .animation(.spring(duration: 0.2), value: self.isValid)
    }
  }
}
