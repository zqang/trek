//
//  RoutePoint.swift
//  Trek
//
//  Model representing a single GPS point along an activity route.
//  Includes coordinates, altitude, timestamp, and speed data.
//

import Foundation
import CoreLocation

/// Represents a single point along an activity route
struct RoutePoint: Codable, Identifiable {
    // MARK: - Properties
    
    /// Unique identifier for the route point
    let id: UUID
    
    /// Latitude coordinate in degrees
    let latitude: Double
    
    /// Longitude coordinate in degrees
    let longitude: Double
    
    /// Altitude above sea level in meters
    let altitude: Double
    
    /// Timestamp when this point was recorded
    let timestamp: Date
    
    /// Speed at this point in meters per second
    /// Optional as GPS may not always provide accurate speed
    let speed: Double?
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        altitude: Double,
        timestamp: Date,
        speed: Double? = nil
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
        self.speed = speed
    }
    
    /// Convenience initializer from CLLocation
    init(from location: CLLocation) {
        self.id = UUID()
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.timestamp = location.timestamp
        self.speed = location.speed >= 0 ? location.speed : nil
    }
    
    // MARK: - Computed Properties
    
    /// Convert to CLLocationCoordinate2D for map usage
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Convert to CLLocation for distance calculations
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            timestamp: timestamp
        )
    }
    
    /// Speed in km/h (converted from m/s)
    var speedKmh: Double? {
        guard let speed = speed else { return nil }
        return speed * 3.6
    }
}

// MARK: - Distance Calculation Extension
extension RoutePoint {
    /// Calculate distance to another route point in meters
    func distance(to otherPoint: RoutePoint) -> Double {
        return location.distance(from: otherPoint.location)
    }
}

// MARK: - Array Extension for Route Analysis
extension Array where Element == RoutePoint {
    /// Calculate total distance of the route in meters
    var totalDistance: Double {
        guard count > 1 else { return 0 }
        
        var total: Double = 0
        for i in 0..<(count - 1) {
            total += self[i].distance(to: self[i + 1])
        }
        return total
    }
    
    /// Calculate total elevation gain in meters
    var totalElevationGain: Double {
        guard count > 1 else { return 0 }
        
        var gain: Double = 0
        for i in 0..<(count - 1) {
            let elevationChange = self[i + 1].altitude - self[i].altitude
            if elevationChange > 0 {
                gain += elevationChange
            }
        }
        return gain
    }
    
    /// Get the duration of the route in seconds
    var duration: TimeInterval? {
        guard let first = first, let last = last else { return nil }
        return last.timestamp.timeIntervalSince(first.timestamp)
    }
}
