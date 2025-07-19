//
//  PeaksTextFieldStyle.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//


import SwiftUI

// Structure creating a custom textFieldStyle
struct PeaksTextFieldStyle: TextFieldStyle {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    var isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        let empty = text.isEmpty
        let fg: Color = {
            if !isValid {
                return .red
            } else {
                return isFocused || !empty ? .black : .secondary
            }
        }()
        
        let isFieldFocused: Bool = {
            if !isValid || isFocused {
                return true
            } else {
                return false
            }
        }()
        
        configuration
            .overlay(alignment: .trailing) {
                if !empty && isFocused {
                    Button { text = "" } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                            .fontWeight(.medium)
                    }
                }
            }
            .focused($isFocused)
            .focusStroke(isFocused: isFieldFocused, focusColor: fg)
            .animation(.spring(duration: 0.4), value: isFocused)
            .animation(.spring(duration: 0.4), value: isValid)
    }
}
