//
//  AppIconView.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

@Observable
class AppIconLoader {
    var image: UIImage?

    init() {
        DispatchQueue.global(qos: .background).async {
            let icon = UIApplication.shared.appIcon
            DispatchQueue.main.async {
                self.image = icon
            }
        }
    }
}

struct AppIconView: View {
    @State private var loader = AppIconLoader()
    @State private var size: CGSize = .zero

    var body: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
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
}
