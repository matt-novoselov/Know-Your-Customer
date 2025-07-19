//
//  File.swift
//  Peaks KYC
//
//  Created by Matt Novoselov on 19/07/25.
//

import SwiftUI

struct AnimatedColorsMeshGradientView: View {
    private let colors: [Color] = [
        .brand.mix(with: .white, by: 0.5), .brand.mix(with: .white, by: 0.5), .brand.mix(with: .white, by: 0.5),
        .brand, .brand, .purple.mix(with: .white, by: 0.7),
        .brand, .pink.mix(with: .white, by: 0.5), .brand,
        .purple, .brand, .brand,
        .brand, .brand, .brand,
    ]
    
    private let points: [SIMD2<Float>] = [
        SIMD2<Float>(0.0, 0.0), SIMD2<Float>(0.5, 0.0), SIMD2<Float>(1.0, 0.0),
        SIMD2<Float>(0.0, 0.25), SIMD2<Float>(0.5, 0.25), SIMD2<Float>(1.0, 0.25),
        SIMD2<Float>(0.0, 0.50), SIMD2<Float>(0.5, 0.50), SIMD2<Float>(1.0, 0.50),
        SIMD2<Float>(0.0, 0.75), SIMD2<Float>(0.5, 0.75), SIMD2<Float>(1.0, 0.75),
        SIMD2<Float>(0.0, 1.0), SIMD2<Float>(0.5, 1.0), SIMD2<Float>(1.0, 1.0)
    ]
}

extension AnimatedColorsMeshGradientView {
    var body: some View {
        TimelineView(.animation) { timeline in
            MeshGradient(
                width: 3,
                height: 5,
                locations: .points(points),
                colors: .colors(animatedColors(for: timeline.date)),
                background: .white,
                smoothsColors: true
            )
        }
        .opacity(0.8)
        .overlay{
            LinearGradient(
                gradient: Gradient(colors: [.clear, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }
}

extension AnimatedColorsMeshGradientView {
    private func animatedColors(for date: Date) -> [Color] {
        let phase = CGFloat(date.timeIntervalSince1970)
        
        return colors.enumerated().map { index, color in
            let hueShift = cos(phase + Double(index) * 0.3) * 0.1
            return shiftHue(of: color, by: hueShift)
        }
    }
    
    private func shiftHue(of color: Color, by amount: Double) -> Color {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        UIColor(color).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        hue += CGFloat(amount)
        hue = hue.truncatingRemainder(dividingBy: 1.0)
        
        if hue < 0 {
            hue += 1
        }
        
        return Color(hue: Double(hue), saturation: Double(saturation), brightness: Double(brightness), opacity: Double(alpha))
    }
}
