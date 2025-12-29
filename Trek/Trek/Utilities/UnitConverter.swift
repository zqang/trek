//
//  UnitConverter.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation

struct UnitConverter {

    // MARK: - Distance Conversions
    static func metersToKilometers(_ meters: Double) -> Double {
        return meters / 1000
    }

    static func metersToMiles(_ meters: Double) -> Double {
        return meters / 1609.34
    }

    static func kilometersToMeters(_ km: Double) -> Double {
        return km * 1000
    }

    static func milesToMeters(_ miles: Double) -> Double {
        return miles * 1609.34
    }

    // MARK: - Speed Conversions
    static func metersPerSecondToKmPerHour(_ mps: Double) -> Double {
        return mps * 3.6
    }

    static func metersPerSecondToMilesPerHour(_ mps: Double) -> Double {
        return mps * 2.23694
    }

    static func kmPerHourToMetersPerSecond(_ kmh: Double) -> Double {
        return kmh / 3.6
    }

    static func milesPerHourToMetersPerSecond(_ mph: Double) -> Double {
        return mph / 2.23694
    }

    // MARK: - Pace Conversions
    /// Convert seconds per kilometer to seconds per mile
    static func secondsPerKmToSecondsPerMile(_ secPerKm: Double) -> Double {
        return secPerKm * 1.60934
    }

    /// Convert seconds per mile to seconds per kilometer
    static func secondsPerMileToSecondsPerKm(_ secPerMile: Double) -> Double {
        return secPerMile / 1.60934
    }

    // MARK: - Elevation Conversions
    static func metersToFeet(_ meters: Double) -> Double {
        return meters * 3.28084
    }

    static func feetToMeters(_ feet: Double) -> Double {
        return feet / 3.28084
    }

    // MARK: - Split Distance
    static func splitDistance(for unit: UnitSystem) -> Double {
        switch unit {
        case .metric:
            return 1000  // 1 km
        case .imperial:
            return 1609.34  // 1 mile
        }
    }
}
