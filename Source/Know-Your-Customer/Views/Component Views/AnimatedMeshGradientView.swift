//
//  AnimatedMeshGradientView.swift
//  Know Your Customer
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

// Displays an animated, colorful background mesh.
struct AnimatedMeshGradientView: View {
    // MARK: - Configuration
    private let rows: Int = 5
    private let columns: Int = 3
    private let baseColors: [Color] = [
        .brand, .brand, .brand,
        .purple.mix(with: .white, by: 0.4), .brand, .purple.mix(with: .white, by: 0.4),
        .purple, .pink.mix(with: .white, by: 0.1), .purple.mix(with: .white, by: 0.4),
        .brand, .pink.mix(with: .white, by: 0.3), .pink.mix(with: .white, by: 0.3),
        .pink, .pink, .brand
    ]

    private var points: [SIMD2<Float>] {
        (0..<rows).flatMap { row in
            (0..<columns).map { col in
                SIMD2<Float>(
                    Float(col) / Float(columns - 1),
                    Float(row) / Float(rows - 1)
                )
            }
        }
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            MeshGradient(
                width: columns,
                height: rows,
                locations: .points(points),
                colors: .colors(animatedColors(for: timeline.date)),
                background: .white,
                smoothsColors: true
            )
        }
        .opacity(0.3)
        .ignoresSafeArea()
    }

    // MARK: - Animation
    private func animatedColors(for date: Date) -> [Color] {
        let phase = CGFloat(date.timeIntervalSince1970)
        return baseColors.enumerated().map { index, color in
            let hueShift = cos(phase + Double(index) * 0.3) * 0.1
            return color.shiftedHue(by: hueShift)
        }
    }
}

private extension Color {
    func shiftedHue(by amount: Double) -> Color {
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        hue = (hue + CGFloat(amount)).truncatingRemainder(dividingBy: 1)
        if hue < 0 { hue += 1 }

        return Color(
            hue: Double(hue),
            saturation: Double(saturation),
            brightness: Double(brightness),
            opacity: Double(alpha)
        )
    }
}
