//
//  ButtonVariant.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

enum ButtonVariant {
    case normal, accent
    
    var background: Color {
        switch self {
        case .normal: return .black
        case .accent: return .brand
        }
    }
    
    var foreground: Color {
        switch self {
        case .normal: return .white
        case .accent: return .black
        }
    }
}
