//
//  Activity.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import CoreLocation

struct Activity: Codable, Identifiable {
    var id: String?
    let userId: String
    var name: String
    var type: ActivityType
    let startTime: Date
    let endTime: Date
    let distance: Double  // meters
    let duration: TimeInterval  // seconds (excluding pauses)
    let elevationGain: Double  // meters
    let route: [LocationPoint]
    let splits: [Split]
    var isPrivate: Bool
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case name
        case type
        case startTime
        case endTime
        case distance
        case duration
        case elevationGain
        case route
        case splits
        case isPrivate
        case createdAt
    }

    // Computed properties
    var averagePace: Double {
        // seconds per km
        guard distance > 0 else { return 0 }
        return duration / (distance / 1000)
    }

    var averageSpeed: Double {
        // km/h
        guard duration > 0 else { return 0 }
        return (distance / 1000) / (duration / 3600)
    }

    var displayName: String {
        if !name.isEmpty {
            return name
        }
        // Default name: "Morning Run"
        let timeOfDay = startTime.timeOfDay
        return "\(timeOfDay) \(type.displayName)"
    }

    // Initialize from Core Data entity
    init(entity: ActivityEntity) {
        self.id = entity.id?.uuidString
        self.userId = entity.userId?.uuidString ?? ""
        self.name = entity.name ?? ""
        self.type = ActivityType(rawValue: entity.type ?? "run") ?? .run
        self.startTime = entity.startTime ?? Date()
        self.endTime = entity.endTime ?? Date()
        self.distance = entity.distance
        self.duration = entity.duration
        self.elevationGain = entity.elevationGain

        // Decode route from binary data
        if let routeData = entity.routeData {
            self.route = (try? JSONDecoder().decode([LocationPoint].self, from: routeData)) ?? []
        } else {
            self.route = []
        }

        self.splits = []  // Computed from route if needed
        self.isPrivate = false
        self.createdAt = entity.startTime ?? Date()
    }

    init(
        id: String? = nil,
        userId: String,
        name: String = "",
        type: ActivityType,
        startTime: Date,
        endTime: Date,
        distance: Double,
        duration: TimeInterval,
        elevationGain: Double,
        route: [LocationPoint],
        splits: [Split] = [],
        isPrivate: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.type = type
        self.startTime = startTime
        self.endTime = endTime
        self.distance = distance
        self.duration = duration
        self.elevationGain = elevationGain
        self.route = route
        self.splits = splits
        self.isPrivate = isPrivate
        self.createdAt = createdAt
    }
}

// MARK: - Location Point
struct LocationPoint: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let timestamp: Date
    let speed: Double  // m/s
    let horizontalAccuracy: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

// MARK: - Split
struct Split: Codable, Identifiable {
    var id: String { "\(index)" }
    let index: Int  // 1st km, 2nd km, etc.
    let distance: Double  // 1000m or 1609m (1 mile)
    let duration: TimeInterval  // seconds
    let pace: Double  // seconds per km/mi

    var formattedPace: String {
        let minutes = Int(pace / 60)
        let seconds = Int(pace.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Activity Stats
struct ActivityStats {
    let distance: Double
    let duration: TimeInterval
    let pace: Double  // avg seconds per km
    let speed: Double  // avg km/h
    let elevationGain: Double
    let splits: [Split]
}

// MARK: - Date Extension
extension Date {
    var timeOfDay: String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<21: return "Evening"
        default: return "Night"
        }
    }
}
