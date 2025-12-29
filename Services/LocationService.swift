//
//  LocationService.swift
//  Trek
//
//  Service for managing GPS location tracking and activity recording.
//  Wraps CLLocationManager to provide location updates with proper permissions handling.
//

import Foundation
import CoreLocation
import Combine

/// Service responsible for managing location tracking for activities
/// Handles permissions, location updates, and route recording
@MainActor
class LocationService: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current user location
    @Published var currentLocation: CLLocation?
    
    /// Array of route points collected during tracking
    @Published var routePoints: [RoutePoint] = []
    
    /// Current authorization status
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Whether location tracking is currently active
    @Published var isTracking: Bool = false
    
    /// Whether tracking is paused
    @Published var isPaused: Bool = false
    
    /// Error message if location services fail
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    /// Core Location manager instance
    private let locationManager = CLLocationManager()
    
    /// Last recorded location (for calculating distances)
    private var lastRecordedLocation: CLLocation?
    
    /// Minimum distance between recorded points (in meters)
    private let minimumDistanceFilter: CLLocationDistance = 10.0
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = Constants.locationDistanceFilter
        locationManager.activityType = .fitness
        
        // Allow background location updates for continuous tracking
        // Note: Requires "location" in UIBackgroundModes in Info.plist
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        // Update authorization status
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // MARK: - Permission Management
    
    /// Request location permission from the user
    /// Call this before starting tracking
    func requestPermission() {
        switch authorizationStatus {
        case .notDetermined:
            // First time - request "when in use" permission
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // Already have "when in use", request "always" for background tracking
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            // Already have full permission
            break
        case .denied, .restricted:
            errorMessage = "Location access is required to track activities. Please enable it in Settings."
        @unknown default:
            break
        }
    }
    
    /// Check if we have permission to track location
    var hasPermission: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    // MARK: - Tracking Control
    
    /// Start location tracking for a new activity
    /// Clears previous route points and begins collecting new ones
    func startTracking() {
        guard hasPermission else {
            requestPermission()
            return
        }
        
        // Clear previous route data
        routePoints.removeAll()
        lastRecordedLocation = nil
        
        // Start location updates
        isTracking = true
        isPaused = false
        locationManager.startUpdatingLocation()
        
        print("LocationService: Started tracking")
    }
    
    /// Pause location tracking
    /// Stops collecting new points but maintains current route
    func pauseTracking() {
        guard isTracking else { return }
        
        isPaused = true
        locationManager.stopUpdatingLocation()
        
        print("LocationService: Paused tracking")
    }
    
    /// Resume location tracking after pause
    func resumeTracking() {
        guard isTracking, isPaused else { return }
        
        isPaused = false
        locationManager.startUpdatingLocation()
        
        print("LocationService: Resumed tracking")
    }
    
    /// Stop location tracking and finalize the route
    /// Returns the collected route points
    @discardableResult
    func stopTracking() -> [RoutePoint] {
        isTracking = false
        isPaused = false
        locationManager.stopUpdatingLocation()
        
        let finalRoute = routePoints
        print("LocationService: Stopped tracking. Collected \(finalRoute.count) points")
        
        return finalRoute
    }
    
    // MARK: - Route Calculations
    
    /// Calculate total distance of the current route in meters
    func calculateTotalDistance() -> Double {
        guard routePoints.count >= 2 else { return 0.0 }
        
        var totalDistance = 0.0
        for i in 1..<routePoints.count {
            let previousPoint = routePoints[i - 1]
            let currentPoint = routePoints[i]
            totalDistance += previousPoint.distance(to: currentPoint)
        }
        
        return totalDistance
    }
    
    /// Calculate total elevation gain in meters
    func calculateElevationGain() -> Double {
        guard routePoints.count >= 2 else { return 0.0 }
        
        var totalGain = 0.0
        for i in 1..<routePoints.count {
            let elevationChange = routePoints[i - 1].elevationChange(to: routePoints[i])
            if elevationChange > 0 {
                totalGain += elevationChange
            }
        }
        
        return totalGain
    }
    
    /// Calculate average speed in meters per second
    func calculateAverageSpeed() -> Double {
        guard !routePoints.isEmpty else { return 0.0 }
        
        let totalSpeed = routePoints.reduce(0.0) { $0 + $1.speed }
        return totalSpeed / Double(routePoints.count)
    }
    
    /// Calculate maximum speed in meters per second
    func calculateMaxSpeed() -> Double {
        guard !routePoints.isEmpty else { return 0.0 }
        
        return routePoints.map { $0.speed }.max() ?? 0.0
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    /// Called when authorization status changes
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            
            // If permission was just granted and we're trying to track, start now
            if hasPermission && isTracking && !isPaused {
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    /// Called when new locations are available
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last, isTracking, !isPaused else { return }
            
            // Update current location
            currentLocation = location
            
            // Only record point if it meets quality and distance criteria
            guard shouldRecordLocation(location) else { return }
            
            // Create and add route point
            let routePoint = RoutePoint(from: location)
            if routePoint.isValid {
                routePoints.append(routePoint)
                lastRecordedLocation = location
                
                print("LocationService: Recorded point #\(routePoints.count) - Speed: \(String(format: "%.1f", routePoint.speedInKilometersPerHour)) km/h")
            }
        }
    }
    
    /// Called when location updates fail
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            print("LocationService: Error - \(error.localizedDescription)")
            errorMessage = "Failed to get location: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Helper Methods
    
    /// Determine if a location should be recorded based on quality and distance
    private func shouldRecordLocation(_ location: CLLocation) -> Bool {
        // Check if location is recent (within 10 seconds)
        guard location.timestamp.timeIntervalSinceNow > -10 else {
            return false
        }
        
        // Check horizontal accuracy (reject if too inaccurate)
        guard location.horizontalAccuracy > 0 && location.horizontalAccuracy < 100 else {
            return false
        }
        
        // For first point, always record
        guard let lastLocation = lastRecordedLocation else {
            return true
        }
        
        // Check if we've moved enough distance since last point
        let distance = location.distance(from: lastLocation)
        return distance >= minimumDistanceFilter
    }
}

// MARK: - Background Tracking Notes

/*
 To enable background location tracking:
 
 1. Add "location" to UIBackgroundModes in Info.plist
 2. Add location permission descriptions:
    - NSLocationWhenInUseUsageDescription
    - NSLocationAlwaysAndWhenInUseUsageDescription
 
 3. Request "Always" authorization (not just "When In Use")
 4. Set allowsBackgroundLocationUpdates = true (done above)
 5. Set pausesLocationUpdatesAutomatically = false (done above)
 
 Important considerations:
 - Background location significantly impacts battery life
 - Apple reviews apps with background location carefully
 - Must clearly explain to users why background access is needed
 - Consider adding user controls to limit background tracking
 - Monitor battery usage and optimize as needed
 */
