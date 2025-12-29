//
//  Constants.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

// MARK: - App Constants
enum Constants {
    // MARK: - App Info
    static let appName = "Trek"
    static let appVersion = "1.0.0"
    static let supportEmail = "support@trek-app.com"

    // MARK: - Default Values
    static let defaultSplitDistance = 1000.0  // meters (1 km)
    static let defaultLocationAccuracy = 50.0  // meters
    static let minGPSAccuracy = 50.0  // meters
    static let minMovementSpeed = 0.5  // m/s (ignore GPS drift)

    // MARK: - Auto-save
    static let autoSaveInterval: TimeInterval = 30.0  // seconds

    // MARK: - Animation
    static let standardAnimationDuration: Double = 0.3
}

// MARK: - Color Palette
extension Color {
    // MARK: - Primary Colors
    static let trekPrimary = Color("TrekPrimary")
    static let trekSecondary = Color("TrekSecondary")
    static let trekAccent = Color.accentColor

    // MARK: - Background Colors
    static let trekBackground = Color("TrekBackground")
    static let trekSecondaryBackground = Color("TrekSecondaryBackground")

    // MARK: - Text Colors
    static let trekPrimaryText = Color.primary
    static let trekSecondaryText = Color.secondary

    // MARK: - Status Colors
    static let trekSuccess = Color.green
    static let trekWarning = Color.orange
    static let trekError = Color.red

    // MARK: - Activity Type Colors
    static let activityRun = Color.blue
    static let activityRide = Color.orange
    static let activityWalk = Color.green
    static let activityHike = Color.purple
}

// MARK: - Spacing
enum Spacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
}

// MARK: - Corner Radius
enum CornerRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 24
}
