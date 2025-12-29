//
//  LocationService.swift
//  Trek
//
//  Service for managing GPS location tracking during activities.
//  Wraps CLLocationManager to provide location updates and route tracking.
//

import Foundation
import CoreLocation
import Combine

/// Service responsible for tracking user location during activities
@MainActor
class LocationService: NSObject, ObservableObject {
    // MARK: - Published Properties
    
    /// Current user location
    @Published var currentLocation: CLLocation?
    
    /// Array of route points collected during tracking
    @Published var routePoints: [RoutePoint] = []
    
    /// Current authorization status
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Whether location tracking is active
    @Published var isTracking = false
    
    // MARK: - Private Properties
    
    private let locationManager = CLLocationManager()
    private var isPaused = false
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        locationManager.activityType = .fitness
        
        // For background location tracking
        // Note: Requires "location" in UIBackgroundModes in Info.plist
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // MARK: - Public Methods
    
    /// Request location permission from the user
    func requestPermission() {
        // Request "When In Use" authorization first
        // For background tracking, will need "Always" authorization
        locationManager.requestWhenInUseAuthorization()
        
        // Uncomment to request always authorization for background tracking
        // locationManager.requestAlwaysAuthorization()
    }
    
    /// Start tracking user location
    func startTracking() {
        guard authorizationStatus == .authorizedWhenInUse || 
              authorizationStatus == .authorizedAlways else {
            print("Location access not authorized")
            requestPermission()
            return
        }
        
        isTracking = true
        isPaused = false
        locationManager.startUpdatingLocation()
        
        // TODO: Consider starting significant location changes for battery efficiency
        // locationManager.startMonitoringSignificantLocationChanges()
    }
    
    /// Pause tracking (stops collecting route points but keeps location updates)
    func pauseTracking() {
        isPaused = true
        // Continue location updates but don't add to route
    }
    
    /// Resume tracking after pause
    func resumeTracking() {
        isPaused = false
    }
    
    /// Stop tracking completely
    func stopTracking() {
        isTracking = false
        isPaused = false
        locationManager.stopUpdatingLocation()
    }
    
    /// Clear all collected route points
    func clearRoute() {
        routePoints.removeAll()
    }
    
    /// Calculate total distance of current route in kilometers
    func getTotalDistance() -> Double {
        return routePoints.totalDistance / 1000.0 // Convert meters to km
    }
    
    /// Calculate total elevation gain in meters
    func getTotalElevationGain() -> Double {
        return routePoints.totalElevationGain
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            
            // Handle authorization changes
            switch authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                print("Location access granted")
            case .denied, .restricted:
                print("Location access denied")
            case .notDetermined:
                print("Location access not determined")
            @unknown default:
                break
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let location = locations.last else { return }
            
            // Update current location
            currentLocation = location
            
            // Add to route if tracking and not paused
            if isTracking && !isPaused {
                let routePoint = RoutePoint(from: location)
                routePoints.append(routePoint)
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            print("Location manager error: \(error.localizedDescription)")
            
            // Handle specific error cases
            if let clError = error as? CLError {
                switch clError.code {
                case .denied:
                    print("User denied location access")
                case .locationUnknown:
                    print("Location unknown - GPS signal may be weak")
                default:
                    print("Location error code: \(clError.code.rawValue)")
                }
            }
        }
    }
}

// MARK: - Background Location Notes
/*
 To enable background location tracking:
 
 1. Add "location" to UIBackgroundModes in Info.plist
 2. Request "Always" authorization instead of "When In Use"
 3. Set allowsBackgroundLocationUpdates = true (already done)
 4. Consider using significant location changes for better battery life
 
 Info.plist keys needed:
 - NSLocationWhenInUseUsageDescription
 - NSLocationAlwaysAndWhenInUseUsageDescription (for background tracking)
 
 Background modes:
 - UIBackgroundModes: ["location"]
 */
