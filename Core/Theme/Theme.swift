//
//  Theme.swift
//  Trek
//
//  Centralized theming system for Trek app.
//  Defines colors, fonts, and other visual styling elements.
//

import SwiftUI

// MARK: - Color Extension

extension Color {
    /// Primary brand color - used for main actions and key UI elements
    static let trekPrimary = Color(red: 0.0, green: 0.48, blue: 0.8) // Blue
    
    /// Secondary brand color - used for accents and secondary actions
    static let trekSecondary = Color(red: 0.2, green: 0.8, blue: 0.4) // Green
    
    /// Accent color for highlights and important info
    static let trekAccent = Color(red: 1.0, green: 0.6, blue: 0.0) // Orange
    
    /// Background color for cards and elevated surfaces
    static let trekCardBackground = Color(UIColor.secondarySystemBackground)
    
    /// Background color for the main app
    static let trekBackground = Color(UIColor.systemBackground)
    
    /// Text color for primary content
    static let trekTextPrimary = Color(UIColor.label)
    
    /// Text color for secondary/supporting content
    static let trekTextSecondary = Color(UIColor.secondaryLabel)
    
    /// Color for success states (e.g., completed activities)
    static let trekSuccess = Color.green
    
    /// Color for warning states
    static let trekWarning = Color.orange
    
    /// Color for error states
    static let trekError = Color.red
}

// MARK: - Theme

/// Centralized theme configuration
struct Theme {
    
    // MARK: - Colors
    
    struct Colors {
        static let primary = Color.trekPrimary
        static let secondary = Color.trekSecondary
        static let accent = Color.trekAccent
        static let background = Color.trekBackground
        static let cardBackground = Color.trekCardBackground
        static let textPrimary = Color.trekTextPrimary
        static let textSecondary = Color.trekTextSecondary
        static let success = Color.trekSuccess
        static let warning = Color.trekWarning
        static let error = Color.trekError
    }
    
    // MARK: - Fonts
    
    struct Fonts {
        /// Large title font for major headings
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        
        /// Title font for section headers
        static let title = Font.system(size: 28, weight: .bold, design: .rounded)
        
        /// Title font for smaller section headers
        static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
        
        /// Headline font for prominent text
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        
        /// Body font for regular content
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        
        /// Callout font for supporting text
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        
        /// Subheadline font for secondary text
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        
        /// Caption font for small supporting text
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        
        /// Font for displaying numerical stats
        static let stat = Font.system(size: 24, weight: .bold, design: .rounded)
        
        /// Font for displaying large numerical values
        static let statLarge = Font.system(size: 48, weight: .bold, design: .rounded)
    }
    
    // MARK: - Spacing
    
    struct Spacing {
        /// Extra small spacing (4pt)
        static let xs: CGFloat = 4
        
        /// Small spacing (8pt)
        static let sm: CGFloat = 8
        
        /// Medium spacing (16pt)
        static let md: CGFloat = 16
        
        /// Large spacing (24pt)
        static let lg: CGFloat = 24
        
        /// Extra large spacing (32pt)
        static let xl: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        /// Small corner radius for buttons and small cards
        static let sm: CGFloat = 8
        
        /// Medium corner radius for cards
        static let md: CGFloat = 12
        
        /// Large corner radius for larger cards
        static let lg: CGFloat = 16
    }
    
    // MARK: - Shadow
    
    struct Shadow {
        /// Light shadow for subtle elevation
        static let light = (color: Color.black.opacity(0.1), radius: CGFloat(4), x: CGFloat(0), y: CGFloat(2))
        
        /// Medium shadow for cards
        static let medium = (color: Color.black.opacity(0.15), radius: CGFloat(8), x: CGFloat(0), y: CGFloat(4))
        
        /// Heavy shadow for floating elements
        static let heavy = (color: Color.black.opacity(0.2), radius: CGFloat(16), x: CGFloat(0), y: CGFloat(8))
    }
}

// MARK: - View Extension for Theming

extension View {
    /// Apply card styling to a view
    func cardStyle() -> some View {
        self
            .background(Theme.Colors.cardBackground)
            .cornerRadius(Theme.CornerRadius.md)
            .shadow(
                color: Theme.Shadow.light.color,
                radius: Theme.Shadow.light.radius,
                x: Theme.Shadow.light.x,
                y: Theme.Shadow.light.y
            )
    }
}
