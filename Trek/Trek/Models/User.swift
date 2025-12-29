//
//  User.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let email: String
    var name: String
    var profilePhotoURL: String?
    var totalDistance: Double  // meters
    var totalActivities: Int
    var totalDuration: TimeInterval  // seconds
    var preferredUnits: UnitSystem
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case profilePhotoURL
        case totalDistance
        case totalActivities
        case totalDuration
        case preferredUnits
        case createdAt
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
