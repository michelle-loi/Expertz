//
//  GlassBackground.swift
//  Expertz
//
//  Created by Mark on 2025-02-18.
//

import SwiftUI

/// A reusable glass-effect background view with a teal/turquoise tint.
struct GlassBackground: View {
    var body: some View {
        ZStack {
            // Use the system ultra-thin material for the glass effect.
            Color.clear
                .background(.ultraThinMaterial)
                .overlay(
                    // Overlay a teal/turquoise tinted gradient.
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.00, green: 0.75, blue: 0.70),
                            Color(red: 0.00, green: 0.60, blue: 0.65)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blendMode(.overlay)
                    .opacity(0.4)
                )
        }
        .ignoresSafeArea()
    }
}
