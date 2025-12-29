//
//  LaunchScreenView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

/// Launch screen view displayed while app is loading
/// Shows Trek branding with smooth fade-in animation
struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.blue,
                    Color.blue.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // App icon placeholder (mountain symbol)
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)

                    // Mountain icon
                    Image(systemName: "mountain.2.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)

                // App name
                Text("Trek")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(opacity)

                // Tagline
                Text("Track Your Journey")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
