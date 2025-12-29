//
//  ActivityType.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation

enum ActivityType: String, Codable, CaseIterable {
    case run
    case ride
    case walk
    case hike

    var displayName: String {
        switch self {
        case .run: return "Run"
        case .ride: return "Ride"
        case .walk: return "Walk"
        case .hike: return "Hike"
        }
    }

    var icon: String {
        switch self {
        case .run: return "figure.run"
        case .ride: return "bicycle"
        case .walk: return "figure.walk"
        case .hike: return "figure.hiking"
        }
    }

    var primaryMetric: MetricType {
        switch self {
        case .run, .walk, .hike:
            return .pace  // min/km or min/mi
        case .ride:
            return .speed  // km/h or mph
        }
    }

    /// Detect activity type based on average speed
    static func detect(avgSpeed: Double) -> ActivityType {
        // Speed in m/s
        if avgSpeed < 2.5 {
            return .walk  // <9 km/h
        } else if avgSpeed < 5.0 {
            return .run   // <18 km/h
        } else {
            return .ride  // >18 km/h
        }
    }
}

enum MetricType {
    case pace   // minutes per km/mi
    case speed  // km/h or mph
}
