//
//  DebounceModifier.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

// Delays executing an action until the value stops changing for a moment.
struct DebounceModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let delay: TimeInterval
    let action: (Value) -> Void

    @State private var workItem: DispatchWorkItem?

    func body(content: Content) -> some View {
        content
            .onChange(of: value) {
                workItem?.cancel()
                let item = DispatchWorkItem { action(value) }
                workItem = item
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
            }
            .onDisappear {
                workItem?.cancel()
                workItem = nil
            }
    }
}

extension View {
    func onDebouncedChange<Value: Equatable>(
        of value: Value,
        delay: TimeInterval = 0.7,
        perform action: @escaping (Value) -> Void
    ) -> some View {
        modifier(DebounceModifier(value: value, delay: delay, action: action))
    }
}
