//
//  LocationService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import CoreLocation
import Combine
import os.log

private let logger = Logger(subsystem: "com.trek", category: "LocationService")

class LocationService: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var currentLocation: CLLocation?
    @Published var distance: Double = 0  // meters
    @Published var duration: TimeInterval = 0  // seconds
    @Published var currentPace: Double = 0  // seconds per km
    @Published var currentSpeed: Double = 0  // m/s
    @Published var elevationGain: Double = 0  // meters
    @Published var isTracking = false
    @Published var isPaused = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var route: [LocationPoint] = []
    @Published var splits: [Split] = []
    @Published var locationError: LocationError?

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var startTime: Date?
    private var pausedTime: Date?
    private var totalPausedDuration: TimeInterval = 0
    private var lastLocation: CLLocation?
    private var lastElevation: Double = 0
    private var speedBuffer: [Double] = []
    private let kalmanFilter = KalmanFilter()
    private var timer: Timer?
    private var distanceAtLastSplit: Double = 0
    private var timeAtLastSplit: Date?
    private let splitDistance: Double = 1000  // 1 km (will be adjusted based on user preference)

    // MARK: - Initialization
    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10  // meters
        locationManager.activityType = .fitness
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = false  // Foreground only for MVP
        authorizationStatus = locationManager.authorizationStatus
    }

    // MARK: - Permission Management
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Tracking Control
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }

        isTracking = true
        isPaused = false
        startTime = Date()
        timeAtLastSplit = Date()
        distance = 0
        duration = 0
        elevationGain = 0
        route = []
        splits = []
        totalPausedDuration = 0
        lastLocation = nil
        lastElevation = 0
        speedBuffer = []
        distanceAtLastSplit = 0

        locationManager.startUpdatingLocation()
        startTimer()
    }

    func pauseTracking() {
        isPaused = true
        pausedTime = Date()
        locationManager.stopUpdatingLocation()
        stopTimer()
    }

    func resumeTracking() {
        guard let pausedTime = pausedTime else { return }
        isPaused = false
        totalPausedDuration += Date().timeIntervalSince(pausedTime)
        self.pausedTime = nil
        locationManager.startUpdatingLocation()
        startTimer()
    }

    func stopTracking() -> ActivityStats {
        isTracking = false
        isPaused = false
        locationManager.stopUpdatingLocation()
        stopTimer()

        let stats = ActivityStats(
            distance: distance,
            duration: duration,
            pace: distance > 0 ? duration / (distance / 1000) : 0,
            speed: duration > 0 ? (distance / 1000) / (duration / 3600) : 0,
            elevationGain: elevationGain,
            splits: splits
        )

        return stats
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateDuration()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateDuration() {
        guard let startTime = startTime, !isPaused else { return }
        duration = Date().timeIntervalSince(startTime) - totalPausedDuration
    }

    // MARK: - Location Processing
    private func processLocation(_ location: CLLocation) {
        // Filter out inaccurate readings
        guard location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 50 else {
            return
        }

        // Apply Kalman filter for smoothing
        let filteredLocation = kalmanFilter.filter(location)

        // Calculate distance if we have a previous location
        if let lastLocation = lastLocation {
            let segmentDistance = filteredLocation.distance(from: lastLocation)

            // Ignore stationary GPS drift (speed < 0.5 m/s)
            if filteredLocation.speed >= 0.5 || segmentDistance > 5 {
                distance += segmentDistance

                // Calculate elevation gain
                if filteredLocation.altitude > lastElevation + 3 {
                    elevationGain += (filteredLocation.altitude - lastElevation)
                }
                lastElevation = filteredLocation.altitude

                // Check if we've completed a split
                checkForSplit()
            }
        } else {
            lastElevation = filteredLocation.altitude
        }

        lastLocation = filteredLocation
        currentLocation = filteredLocation

        // Update speed with smoothing
        updateSpeed(filteredLocation.speed)

        // Update pace (inverse of speed)
        if currentSpeed > 0 {
            currentPace = 1000 / currentSpeed  // seconds per km
        }

        // Add point to route
        let point = LocationPoint(
            latitude: filteredLocation.coordinate.latitude,
            longitude: filteredLocation.coordinate.longitude,
            altitude: filteredLocation.altitude,
            timestamp: filteredLocation.timestamp,
            speed: filteredLocation.speed,
            horizontalAccuracy: filteredLocation.horizontalAccuracy
        )
        route.append(point)
    }

    private func updateSpeed(_ speed: Double) {
        speedBuffer.append(speed)
        if speedBuffer.count > 10 {
            speedBuffer.removeFirst()
        }
        currentSpeed = speedBuffer.reduce(0, +) / Double(speedBuffer.count)
    }

    private func checkForSplit() {
        let distanceSinceLastSplit = distance - distanceAtLastSplit

        if distanceSinceLastSplit >= splitDistance {
            guard let timeAtLastSplit = timeAtLastSplit else { return }

            let splitDuration = Date().timeIntervalSince(timeAtLastSplit)
            let splitPace = splitDuration / (splitDistance / 1000)

            let split = Split(
                index: splits.count + 1,
                distance: splitDistance,
                duration: splitDuration,
                pace: splitPace
            )
            splits.append(split)

            distanceAtLastSplit = distance
            self.timeAtLastSplit = Date()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last, isTracking, !isPaused else { return }
        locationError = nil  // Clear error on successful update
        processLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                locationError = .permissionDenied
            case .locationUnknown:
                locationError = .locationUnavailable
            case .network:
                locationError = .networkError
            default:
                locationError = .unknown(clError.localizedDescription)
            }
        } else {
            locationError = .unknown(error.localizedDescription)
        }
        logger.error("Location manager failed: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        // Clear or set error based on authorization
        switch authorizationStatus {
        case .denied, .restricted:
            locationError = .permissionDenied
        case .authorizedWhenInUse, .authorizedAlways:
            locationError = nil
        default:
            break
        }
    }
}

// MARK: - Location Errors
enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable
    case networkError
    case signalWeak
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location access is denied. Please enable it in Settings."
        case .locationUnavailable:
            return "Unable to determine your location. Make sure you're outdoors with a clear view of the sky."
        case .networkError:
            return "Network error while getting location. Check your connection."
        case .signalWeak:
            return "GPS signal is weak. Move to an area with better sky visibility."
        case .unknown(let message):
            return "Location error: \(message)"
        }
    }
}
