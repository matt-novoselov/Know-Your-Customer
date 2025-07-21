//
//  DynamicFormStroke.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

extension View {
    func dynamicFormStroke(
        isFocused: Bool,
        isValid: Bool,
        style: CornerStyle = .capsule,
        idleColor: Color = .secondary,
        padding: CGFloat = 20
    ) -> some View {
        let focusColor: Color = isValid ? .primary : .red
        let isStrokeFocused = isFocused || !isValid
        
        return self.dynamicStroke(
            isFocused: isStrokeFocused,
            style: style,
            focusColor: focusColor,
            idleColor: idleColor,
            padding: padding
        )
    }
}
