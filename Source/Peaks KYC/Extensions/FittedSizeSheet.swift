//
//  FittedSizeSheet.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct FittedSizeSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @State private var contentHeight: CGFloat = 400
    let sheetContent: () -> SheetContent
    let isDragIndicatorVisible: Bool

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                sheetContent()
                    .onGeometryChange(for: CGSize.self) { geometry in
                        return geometry.size
                    } action: { newValue in
                        contentHeight = newValue.height
                    }
                    .presentationDetents([.height(contentHeight)])
                    .presentationDragIndicator(isDragIndicatorVisible ? .visible : .hidden)
            }
    }
}

extension View {
    func fittedSizeSheet<Content: View>(
        isPresented: Binding<Bool>,
        isDragIndicatorVisible: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let fittedSheet = FittedSizeSheet(
            isPresented: isPresented,
            sheetContent: content,
            isDragIndicatorVisible: isDragIndicatorVisible
        )

        return modifier(fittedSheet)
    }
}
