//
//  User.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import CoreData

struct User: Codable, Identifiable {
    var id: String?
    let email: String
    var name: String
    var displayName: String?
    var bio: String?
    var profilePhotoURL: String?
    var photoURL: String?  // Alias for profilePhotoURL for convenience
    var totalDistance: Double  // meters
    var totalActivities: Int
    var totalDuration: TimeInterval  // seconds
    var preferredUnits: UnitSystem
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case displayName
        case bio
        case profilePhotoURL
        case photoURL
        case totalDistance
        case totalActivities
        case totalDuration
        case preferredUnits
        case createdAt
    }

    init(
        id: String? = nil,
        email: String,
        name: String,
        displayName: String? = nil,
        bio: String? = nil,
        profilePhotoURL: String? = nil,
        photoURL: String? = nil,
        totalDistance: Double = 0,
        totalActivities: Int = 0,
        totalDuration: TimeInterval = 0,
        preferredUnits: UnitSystem = .metric,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.displayName = displayName
        self.bio = bio
        self.profilePhotoURL = profilePhotoURL
        self.photoURL = photoURL
        self.totalDistance = totalDistance
        self.totalActivities = totalActivities
        self.totalDuration = totalDuration
        self.preferredUnits = preferredUnits
        self.createdAt = createdAt
    }

    // Initialize from Core Data entity
    init(entity: UserEntity) {
        self.id = entity.id?.uuidString
        self.email = entity.email ?? ""
        self.name = entity.name ?? ""
        self.displayName = entity.name
        self.bio = entity.bio
        self.profilePhotoURL = entity.profilePhotoPath
        self.photoURL = entity.profilePhotoPath
        self.totalDistance = entity.totalDistance
        self.totalActivities = Int(entity.totalActivities)
        self.totalDuration = entity.totalDuration
        self.preferredUnits = UnitSystem(rawValue: entity.preferredUnits ?? "metric") ?? .metric
        self.createdAt = entity.createdAt ?? Date()
    }
}

enum UnitSystem: String, Codable {
    case metric
    case imperial

    var distanceUnit: String {
        switch self {
        case .metric: return "km"
        case .imperial: return "mi"
        }
    }

    var paceUnit: String {
        switch self {
        case .metric: return "min/km"
        case .imperial: return "min/mi"
        }
    }

    var speedUnit: String {
        switch self {
        case .metric: return "km/h"
        case .imperial: return "mph"
        }
    }
}
