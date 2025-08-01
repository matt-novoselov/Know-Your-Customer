//
//  AppIconView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Shows the application's icon with perfect Apple rounded corners.
struct AppIconView: View {
    @State private var size: CGSize = .zero

    var body: some View {
        if let appIcon = UIApplication.shared.appIcon {
            Image(uiImage: appIcon)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: size.width / 9 * 2))
                .onGeometryChange(for: CGSize.self) { geometry in
                    return geometry.size
                } action: { newValue in
                    size = newValue
                }
        } else {
            Image(systemName: "xmark.app")
        }
    }
}
