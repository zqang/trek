//
//  Constants.swift
//  Trek
//
//  Application-wide constants including deployment target info and default activity types.
//

import Foundation

struct Constants {
    // MARK: - App Info
    static let appName = "Trek"
    static let minimumIOSVersion = "17.0"
    static let swiftVersion = "5.9"
    
    // MARK: - Activity Types
    enum ActivityType: String, CaseIterable, Codable {
        case running = "Running"
        case cycling = "Cycling"
        case walking = "Walking"
        case hiking = "Hiking"
        case swimming = "Swimming"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .walking: return "figure.walk"
            case .hiking: return "figure.hiking"
            case .swimming: return "figure.pool.swim"
            case .other: return "figure.mixed.cardio"
            }
        }
    }
    
    // MARK: - Map Settings
    static let defaultMapSpan = 0.01 // degrees for map region
    static let locationUpdateInterval: TimeInterval = 5.0 // seconds
    
    // MARK: - Units
    static let distanceUnit = "km"
    static let speedUnit = "km/h"
}
