//
//  FittedSizeSheet.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Fits a sheet's height to the content it presents.
struct ContentFittingSheet<SheetContent: View>: ViewModifier {
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
    func contentFittingSheet<Content: View>(
        isPresented: Binding<Bool>,
        isDragIndicatorVisible: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let fittedSheet = ContentFittingSheet(
            isPresented: isPresented,
            sheetContent: content,
            isDragIndicatorVisible: isDragIndicatorVisible
        )

        return modifier(fittedSheet)
    }
}
