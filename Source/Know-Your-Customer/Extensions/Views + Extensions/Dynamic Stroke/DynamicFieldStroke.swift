//
//  DynamicFormStroke.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 21/07/25.
//

import SwiftUI

extension View {
    // Adds styling for input fields based on the focus and validation state.
    func dynamicFieldStroke(
        isFocused: Bool,
        isDisabled: Bool = false,
        isValid: Bool,
        style: CornerStyle = .capsule,
        idleColor: Color = .secondary,
        padding: CGFloat = 20
    ) -> some View {
        let focusColor: Color = isValid ? .primary : .red
        let isStrokeFocused = isFocused || !isValid

        return self.dynamicStroke(
            isFocused: isStrokeFocused,
            isDisabled: isDisabled,
            style: style,
            focusColor: focusColor,
            idleColor: idleColor,
            padding: padding
        )
    }
}
