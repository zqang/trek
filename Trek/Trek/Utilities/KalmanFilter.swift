//
//  KalmanFilter.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import CoreLocation

/// Simple Kalman filter for GPS coordinate smoothing
class KalmanFilter {
    private var previousLocation: CLLocation?
    private var previousVariance: Double = -1

    private let minAccuracy: Double = 1  // meters
    private let qMetersPerSecond: Double = 3  // process noise

    func filter(_ location: CLLocation) -> CLLocation {
        guard let previousLocation = previousLocation else {
            self.previousLocation = location
            self.previousVariance = location.horizontalAccuracy * location.horizontalAccuracy
            return location
        }

        let timeIncrement = location.timestamp.timeIntervalSince(previousLocation.timestamp)
        guard timeIncrement > 0 else {
            return location
        }

        // Kalman gain calculation
        let accuracy = max(location.horizontalAccuracy, minAccuracy)
        let currentVariance = accuracy * accuracy

        let predictedVariance = previousVariance + timeIncrement * qMetersPerSecond * qMetersPerSecond
        let kalmanGain = predictedVariance / (predictedVariance + currentVariance)

        // Update position
        let newLat = previousLocation.coordinate.latitude + kalmanGain * (location.coordinate.latitude - previousLocation.coordinate.latitude)
        let newLon = previousLocation.coordinate.longitude + kalmanGain * (location.coordinate.longitude - previousLocation.coordinate.longitude)
        let newAlt = previousLocation.altitude + kalmanGain * (location.altitude - previousLocation.altitude)

        // Update variance
        previousVariance = (1 - kalmanGain) * predictedVariance

        let filteredLocation = CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: newLat, longitude: newLon),
            altitude: newAlt,
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            course: location.course,
            speed: location.speed,
            timestamp: location.timestamp
        )

        self.previousLocation = filteredLocation
        return filteredLocation
    }

    func reset() {
        previousLocation = nil
        previousVariance = -1
    }
}
