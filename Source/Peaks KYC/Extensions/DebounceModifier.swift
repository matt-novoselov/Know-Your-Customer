//
//  DebounceModifier.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 22/07/25.
//

import SwiftUI

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
