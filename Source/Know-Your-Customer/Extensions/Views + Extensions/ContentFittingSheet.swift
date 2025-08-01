//
//  FittedSizeSheet.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Fits a sheet's height to the content it presents.
private struct ContentFittedPresentationDetents: ViewModifier {
    @State private var contentHeight: CGFloat = .zero

    func body(content: Content) -> some View {
        content
            .presentationDetents([.height(contentHeight)])
            .onGeometryChange(for: CGSize.self) { geometry in
                return geometry.size
            } action: { newValue in
                contentHeight = newValue.height
            }
    }
}

extension View {
    func fittedPresentationDetents() -> some View {
        modifier(ContentFittedPresentationDetents())
    }
}
