//
//  RoutePoint.swift
//  Trek
//
//  Model representing a single GPS coordinate point along an activity route.
//  Stores location data, altitude, timestamp, and speed information.
//

import Foundation
import CoreLocation
import SwiftData

/// Represents a single GPS coordinate point recorded during activity tracking
/// Forms part of the complete route when multiple points are connected
@Model
final class RoutePoint {
    
    // MARK: - Properties
    
    /// Unique identifier for the route point
    var id: UUID
    
    /// Latitude coordinate (-90 to 90 degrees)
    var latitude: Double
    
    /// Longitude coordinate (-180 to 180 degrees)
    var longitude: Double
    
    /// Altitude/elevation in meters above sea level
    var altitude: Double
    
    /// Timestamp when this point was recorded
    var timestamp: Date
    
    /// Speed at this point in meters per second
    var speed: Double
    
    /// Horizontal accuracy of the GPS reading in meters
    /// Smaller values indicate better accuracy
    var horizontalAccuracy: Double
    
    /// Vertical accuracy of the altitude reading in meters
    var verticalAccuracy: Double
    
    /// Course/heading in degrees (0-360, 0 = true north, 90 = east, etc.)
    var course: Double
    
    // MARK: - Computed Properties
    
    /// CLLocationCoordinate2D representation for use with MapKit
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// CLLocation representation with full metadata
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            course: course,
            speed: speed,
            timestamp: timestamp
        )
    }
    
    /// Speed in kilometers per hour
    var speedInKilometersPerHour: Double {
        speed * 3.6
    }
    
    /// Speed in miles per hour
    var speedInMilesPerHour: Double {
        speed * 2.23694
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        altitude: Double = 0.0,
        timestamp: Date = Date(),
        speed: Double = 0.0,
        horizontalAccuracy: Double = 0.0,
        verticalAccuracy: Double = 0.0,
        course: Double = 0.0
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.speed = speed
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.course = course
    }
    
    /// Initialize from CLLocation
    convenience init(from location: CLLocation) {
        self.init(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            timestamp: location.timestamp,
            speed: max(0, location.speed), // Ensure non-negative
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            course: location.course
        )
    }
}

// MARK: - Extensions

extension RoutePoint {
    /// Calculate distance to another route point in meters
    func distance(to otherPoint: RoutePoint) -> Double {
        let fromLocation = CLLocation(latitude: latitude, longitude: longitude)
        let toLocation = CLLocation(latitude: otherPoint.latitude, longitude: otherPoint.longitude)
        return fromLocation.distance(from: toLocation)
    }
    
    /// Calculate elevation change to another route point in meters
    /// Positive value means climbing, negative means descending
    func elevationChange(to otherPoint: RoutePoint) -> Double {
        otherPoint.altitude - altitude
    }
    
    /// Check if this point represents a valid GPS reading
    var isValid: Bool {
        // Basic validation: coordinates within valid ranges and reasonable accuracy
        latitude >= -90 && latitude <= 90 &&
        longitude >= -180 && longitude <= 180 &&
        horizontalAccuracy >= 0 &&
        horizontalAccuracy < 100 // Reject points with poor accuracy (> 100m)
    }
}

// MARK: - Sample Data

extension RoutePoint {
    /// Create sample route point for previews and testing
    static var sample: RoutePoint {
        RoutePoint(
            latitude: 37.7749,
            longitude: -122.4194,
            altitude: 50.0,
            timestamp: Date(),
            speed: 3.5, // m/s (~12.6 km/h)
            horizontalAccuracy: 5.0,
            verticalAccuracy: 3.0,
            course: 90.0 // East
        )
    }
    
    /// Create sample route with multiple points for testing
    static var sampleRoute: [RoutePoint] {
        [
            RoutePoint(latitude: 37.7749, longitude: -122.4194, altitude: 50.0, timestamp: Date(), speed: 0.0),
            RoutePoint(latitude: 37.7750, longitude: -122.4195, altitude: 52.0, timestamp: Date().addingTimeInterval(10), speed: 3.0),
            RoutePoint(latitude: 37.7751, longitude: -122.4196, altitude: 55.0, timestamp: Date().addingTimeInterval(20), speed: 3.5),
            RoutePoint(latitude: 37.7752, longitude: -122.4197, altitude: 58.0, timestamp: Date().addingTimeInterval(30), speed: 4.0),
            RoutePoint(latitude: 37.7753, longitude: -122.4198, altitude: 60.0, timestamp: Date().addingTimeInterval(40), speed: 3.8)
        ]
    }
}
