//
//  NavigationHeaderModifier.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Custom style navigation controller wrapper.
struct NavigationHeaderModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let title: String

    func body(content: Content) -> some View {
        VStack {
            VStack(alignment: .leading, spacing: 15) {
                Button("Back", systemImage: "chevron.left") {
                    dismiss()
                }
                .labelStyle(.iconOnly)
                .fontWeight(.semibold)
                .imageScale(.large)

                Text(title)
                    .font(.dazzed(style: .largeTitle, weight: .heavy))
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            content
                .padding(.top)
        }
        .padding(.top)
        .navigationBarBackButtonHidden()
    }
}

extension View {
    // Convenience for applying the navigation header style.
    func navigationHeader(_ title: String) -> some View {
        modifier(NavigationHeaderModifier(title: title))
    }
}
