//
//  Activity.swift
//  Trek
//
//  Core data model representing a fitness activity.
//  Compatible with SwiftData for persistence.
//

import Foundation
import SwiftData

/// Represents a completed or in-progress fitness activity
/// Stores all metrics and metadata for tracked workouts
@Model
final class Activity {
    
    // MARK: - Properties
    
    /// Unique identifier for the activity
    var id: UUID
    
    /// Type of activity (running, cycling, etc.)
    var type: String
    
    /// Name/title of the activity
    var name: String
    
    /// Start timestamp of the activity
    var startDate: Date
    
    /// End timestamp of the activity (nil if in progress)
    var endDate: Date?
    
    /// Total distance covered in meters
    var distance: Double
    
    /// Total duration in seconds
    var duration: TimeInterval
    
    /// Total elevation gain in meters
    var elevationGain: Double
    
    /// Estimated calories burned
    var calories: Double
    
    /// Average speed in meters per second
    var averageSpeed: Double
    
    /// Maximum speed in meters per second
    var maxSpeed: Double
    
    /// Average heart rate (optional, for future integration)
    var averageHeartRate: Int?
    
    /// Maximum heart rate (optional, for future integration)
    var maxHeartRate: Int?
    
    /// Notes or comments about the activity
    var notes: String?
    
    /// Weather conditions during activity (optional)
    var weather: String?
    
    /// Route points as relationship
    /// Note: SwiftData relationships require the related model to also be @Model
    /// For now, we'll store route points as a separate relationship
    @Relationship(deleteRule: .cascade)
    var routePoints: [RoutePoint]?
    
    // Alternative: Store route as JSON data if SwiftData relationships are complex
    // var routePointsData: Data?
    
    // MARK: - Computed Properties
    
    /// Formatted distance in kilometers
    var distanceInKilometers: Double {
        distance / 1000.0
    }
    
    /// Formatted distance in miles
    var distanceInMiles: Double {
        distance / 1609.34
    }
    
    /// Average pace in minutes per kilometer
    var pacePerKilometer: Double {
        guard distance > 0 else { return 0 }
        return (duration / 60.0) / distanceInKilometers
    }
    
    /// Average pace in minutes per mile
    var pacePerMile: Double {
        guard distance > 0 else { return 0 }
        return (duration / 60.0) / distanceInMiles
    }
    
    /// Average speed in kilometers per hour
    var speedInKilometersPerHour: Double {
        guard duration > 0 else { return 0 }
        return (distance / 1000.0) / (duration / 3600.0)
    }
    
    /// Average speed in miles per hour
    var speedInMilesPerHour: Double {
        guard duration > 0 else { return 0 }
        return (distance / 1609.34) / (duration / 3600.0)
    }
    
    /// Whether the activity is currently in progress
    var isInProgress: Bool {
        endDate == nil
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        type: String,
        name: String = "",
        startDate: Date = Date(),
        endDate: Date? = nil,
        distance: Double = 0.0,
        duration: TimeInterval = 0.0,
        elevationGain: Double = 0.0,
        calories: Double = 0.0,
        averageSpeed: Double = 0.0,
        maxSpeed: Double = 0.0,
        averageHeartRate: Int? = nil,
        maxHeartRate: Int? = nil,
        notes: String? = nil,
        weather: String? = nil,
        routePoints: [RoutePoint]? = nil
    ) {
        self.id = id
        self.type = type
        self.name = name.isEmpty ? "\(type) Activity" : name
        self.startDate = startDate
        self.endDate = endDate
        self.distance = distance
        self.duration = duration
        self.elevationGain = elevationGain
        self.calories = calories
        self.averageSpeed = averageSpeed
        self.maxSpeed = maxSpeed
        self.averageHeartRate = averageHeartRate
        self.maxHeartRate = maxHeartRate
        self.notes = notes
        self.weather = weather
        self.routePoints = routePoints
    }
}

// MARK: - Extensions

extension Activity {
    /// Format duration as HH:MM:SS or MM:SS
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// Format distance based on user preference
    func formattedDistance(unit: Constants.DistanceUnit = .metric) -> String {
        switch unit {
        case .metric:
            return String(format: "%.2f km", distanceInKilometers)
        case .imperial:
            return String(format: "%.2f mi", distanceInMiles)
        }
    }
    
    /// Format speed based on user preference
    func formattedSpeed(unit: Constants.DistanceUnit = .metric) -> String {
        switch unit {
        case .metric:
            return String(format: "%.1f km/h", speedInKilometersPerHour)
        case .imperial:
            return String(format: "%.1f mph", speedInMilesPerHour)
        }
    }
}

// MARK: - Sample Data

extension Activity {
    /// Create sample activity for previews and testing
    static var sample: Activity {
        Activity(
            type: Constants.ActivityType.running.rawValue,
            name: "Morning Run",
            startDate: Date().addingTimeInterval(-3600),
            endDate: Date(),
            distance: 5200.0, // 5.2 km
            duration: 1725.0, // 28:45
            elevationGain: 152.0,
            calories: 420.0,
            averageSpeed: 3.0, // m/s (10.8 km/h)
            maxSpeed: 4.2 // m/s (15.1 km/h)
        )
    }
}
