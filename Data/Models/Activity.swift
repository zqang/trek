//
//  Activity.swift
//  Trek
//
//  SwiftData model representing a tracked fitness activity.
//  Includes metrics like distance, duration, elevation, and route data.
//

import Foundation
import SwiftData

// Note: SwiftData is available in iOS 17+
// This model uses @Model macro for SwiftData persistence
@Model
class Activity {
    // MARK: - Properties
    
    /// Unique identifier for the activity
    var id: UUID
    
    /// Type of activity (running, cycling, etc.)
    var type: String // Stored as String to work with SwiftData
    
    /// When the activity started
    var startDate: Date
    
    /// When the activity ended
    var endDate: Date
    
    /// Total distance covered in kilometers
    var distance: Double
    
    /// Duration of the activity in seconds
    var duration: TimeInterval
    
    /// Total elevation gain in meters
    var elevationGain: Double
    
    /// Calories burned during the activity
    var calories: Int
    
    /// Route points recorded during the activity
    /// Note: In a full implementation, this would be a relationship to RoutePoint entities
    /// For now, stored as JSON-encoded data
    var routePointsData: Data?
    
    // MARK: - Computed Properties
    
    /// Average speed in km/h
    var averageSpeed: Double {
        guard duration > 0 else { return 0 }
        return (distance / (duration / 3600))
    }
    
    /// Average pace in minutes per km (for running/walking)
    var averagePace: Double {
        guard distance > 0 else { return 0 }
        return (duration / 60) / distance
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        type: String,
        startDate: Date,
        endDate: Date,
        distance: Double,
        duration: TimeInterval,
        elevationGain: Double = 0.0,
        calories: Int = 0,
        routePointsData: Data? = nil
    ) {
        self.id = id
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.distance = distance
        self.duration = duration
        self.elevationGain = elevationGain
        self.calories = calories
        self.routePointsData = routePointsData
    }
    
    // MARK: - Helper Methods
    
    /// Encode route points to JSON data for storage
    static func encodeRoutePoints(_ points: [RoutePoint]) -> Data? {
        try? JSONEncoder().encode(points)
    }
    
    /// Decode route points from JSON data
    func decodeRoutePoints() -> [RoutePoint]? {
        guard let data = routePointsData else { return nil }
        return try? JSONDecoder().decode([RoutePoint].self, from: data)
    }
}

// MARK: - Activity Extension for ActivityType
extension Activity {
    /// Get the activity type as a Constants.ActivityType enum
    var activityType: Constants.ActivityType {
        Constants.ActivityType(rawValue: type) ?? .other
    }
    
    /// Set the activity type from a Constants.ActivityType enum
    func setActivityType(_ activityType: Constants.ActivityType) {
        self.type = activityType.rawValue
    }
}
