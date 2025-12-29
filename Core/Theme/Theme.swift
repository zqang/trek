//
//  Theme.swift
//  Trek
//
//  App-wide theme definitions including colors, fonts, and styling.
//

import SwiftUI

// MARK: - Color Extension
extension Color {
    // Primary Colors
    static let trekPrimary = Color(red: 0.0, green: 0.48, blue: 0.99) // Blue
    static let trekSecondary = Color(red: 0.35, green: 0.87, blue: 0.56) // Green
    static let trekAccent = Color(red: 1.0, green: 0.38, blue: 0.27) // Coral
    
    // Background Colors
    static let trekBackground = Color(uiColor: .systemBackground)
    static let trekSecondaryBackground = Color(uiColor: .secondarySystemBackground)
    
    // Text Colors
    static let trekTextPrimary = Color(uiColor: .label)
    static let trekTextSecondary = Color(uiColor: .secondaryLabel)
}

// MARK: - Theme
struct Theme {
    // Colors
    struct Colors {
        static let primary = Color.trekPrimary
        static let secondary = Color.trekSecondary
        static let accent = Color.trekAccent
        static let background = Color.trekBackground
        static let secondaryBackground = Color.trekSecondaryBackground
        static let textPrimary = Color.trekTextPrimary
        static let textSecondary = Color.trekTextSecondary
    }
    
    // Typography
    struct Fonts {
        static let largeTitle = Font.system(size: 34, weight: .bold)
        static let title = Font.system(size: 28, weight: .semibold)
        static let title2 = Font.system(size: 22, weight: .semibold)
        static let headline = Font.system(size: 17, weight: .semibold)
        static let body = Font.system(size: 17, weight: .regular)
        static let callout = Font.system(size: 16, weight: .regular)
        static let subheadline = Font.system(size: 15, weight: .regular)
        static let footnote = Font.system(size: 13, weight: .regular)
        static let caption = Font.system(size: 12, weight: .regular)
    }
    
    // Spacing
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    
    // Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
}
