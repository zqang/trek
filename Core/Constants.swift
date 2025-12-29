//
//  Constants.swift
//  Trek
//
//  App-wide constants and configuration values.
//

import Foundation

/// Central location for app-wide constants
enum Constants {
    
    // MARK: - App Configuration
    
    /// Minimum iOS deployment target for Trek
    static let minimumIOSVersion = "17.0"
    
    /// App version (should be synced with Xcode project)
    static let appVersion = "1.0.0"
    
    // MARK: - Activity Types
    
    /// Supported activity types in Trek
    enum ActivityType: String, CaseIterable, Identifiable {
        case running = "Running"
        case cycling = "Cycling"
        case hiking = "Hiking"
        case walking = "Walking"
        case swimming = "Swimming"
        case skiing = "Skiing"
        case other = "Other"
        
        var id: String { rawValue }
        
        /// SF Symbol name for the activity type
        var iconName: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .hiking: return "figure.hiking"
            case .walking: return "figure.walk"
            case .swimming: return "figure.pool.swim"
            case .skiing: return "figure.skiing.downhill"
            case .other: return "figure.outdoor.cycle"
            }
        }
    }
    
    // MARK: - Location Tracking
    
    /// Distance filter for location updates (in meters)
    /// Smaller values = more accurate but higher battery usage
    static let locationDistanceFilter = 10.0
    
    /// Desired location accuracy for tracking
    static let locationAccuracy = 10.0 // meters
    
    // MARK: - Map Configuration
    
    /// Default map zoom level (in meters)
    static let defaultMapRadius = 1000.0
    
    // MARK: - Units
    
    /// Distance unit system
    enum DistanceUnit: String {
        case metric = "Kilometers"
        case imperial = "Miles"
        
        var speedUnit: String {
            switch self {
            case .metric: return "km/h"
            case .imperial: return "mph"
            }
        }
    }
    
    /// Default distance unit (can be made user-configurable later)
    static let defaultDistanceUnit = DistanceUnit.metric
    
    // MARK: - Formatting
    
    /// Number of decimal places for distance display
    static let distanceDecimalPlaces = 2
    
    /// Number of decimal places for speed display
    static let speedDecimalPlaces = 1
}
