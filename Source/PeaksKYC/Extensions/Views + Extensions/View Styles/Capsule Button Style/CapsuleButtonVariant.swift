//
//  ButtonVariant.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

enum CapsuleButtonVariant {
    // Color schemes used by `CapsuleButtonStyle`.
    case normal, brand

    var background: Color {
        switch self {
        case .normal: return .primary
        case .brand: return .brand
        }
    }

    var foreground: Color {
        switch self {
        case .normal: return .white
        case .brand: return .primary
        }
    }
}
