//
//  InputFieldsListView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct InputFieldsListView: View {
    let configs: [FieldConfig]
    
    var body: some View {
        ScrollView {
            Group {
                ForEach(configs, id: \.id) { cfg in
                    UniversalFieldView(fieldConfig: cfg)
                        .padding(.vertical, 5)
                }
                
                Spacer()
                    .frame(height: 100)
                
                Button("Continue") {
                    
                }
                .buttonStyle(.capsule)
                .disabled(true)
            }
            .navigationHeader("Personal Details")
            .padding()
        }
    }
}
