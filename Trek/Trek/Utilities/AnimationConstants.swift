//
//  AnimationConstants.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

enum AnimationConstants {
    // MARK: - Durations

    static let short: Double = 0.2
    static let medium: Double = 0.3
    static let long: Double = 0.5
    static let extraLong: Double = 0.8

    // MARK: - Spring Animations

    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let springBouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
    static let springSmooth = Animation.spring(response: 0.3, dampingFraction: 0.8)

    // MARK: - Easing Animations

    static let easeIn = Animation.easeIn(duration: medium)
    static let easeOut = Animation.easeOut(duration: medium)
    static let easeInOut = Animation.easeInOut(duration: medium)

    // MARK: - Linear Animations

    static let linear = Animation.linear(duration: medium)
    static let linearShort = Animation.linear(duration: short)
    static let linearLong = Animation.linear(duration: long)

    // MARK: - Specific Use Cases

    static let buttonPress = Animation.easeIn(duration: 0.1)
    static let buttonRelease = Animation.easeOut(duration: 0.2)
    static let cardAppear = Animation.spring(response: 0.4, dampingFraction: 0.7)
    static let listItemAppear = Animation.easeOut(duration: 0.2)
    static let sheetPresent = Animation.easeInOut(duration: 0.3)
    static let sheetDismiss = Animation.easeInOut(duration: 0.25)
    static let slideIn = Animation.spring(response: 0.3, dampingFraction: 0.8)
    static let fadeIn = Animation.easeIn(duration: 0.2)
    static let fadeOut = Animation.easeOut(duration: 0.15)

    // MARK: - Delays

    static let shortDelay: Double = 0.05
    static let mediumDelay: Double = 0.1
    static let longDelay: Double = 0.2

    // MARK: - Stagger

    static func stagger(index: Int, delay: Double = shortDelay) -> Double {
        Double(index) * delay
    }
}

// MARK: - View Extensions

extension View {
    func animatedAppearance(delay: Double = 0) -> some View {
        self
            .opacity(0)
            .offset(y: 20)
            .onAppear {
                withAnimation(AnimationConstants.cardAppear.delay(delay)) {
                    // Handled by parent
                }
            }
    }

    func pulseAnimation() -> some View {
        self.modifier(PulseModifier())
    }

    func shakeAnimation(trigger: Bool) -> some View {
        self.modifier(ShakeModifier(shakes: trigger ? 2 : 0))
    }
}

// MARK: - Pulse Modifier

struct PulseModifier: ViewModifier {
    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                value: isPulsing
            )
            .onAppear {
                isPulsing = true
            }
    }
}

// MARK: - Shake Modifier

struct ShakeModifier: ViewModifier {
    let shakes: Int
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onChange(of: shakes) { newValue in
                guard newValue > 0 else { return }

                let animation = Animation.easeInOut(duration: 0.1)
                    .repeatCount(newValue * 2, autoreverses: true)

                withAnimation(animation) {
                    offset = 10
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(newValue * 2)) {
                    offset = 0
                }
            }
    }
}

// MARK: - Shimmer Modifier

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.white.opacity(0.3),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 400
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}
