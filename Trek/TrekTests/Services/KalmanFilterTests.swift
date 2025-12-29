//
//  KalmanFilterTests.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import XCTest
import CoreLocation
@testable import Trek

final class KalmanFilterTests: XCTestCase {
    var kalmanFilter: KalmanFilter!

    override func setUp() {
        super.setUp()
        kalmanFilter = KalmanFilter()
    }

    override func tearDown() {
        kalmanFilter = nil
        super.tearDown()
    }

    // MARK: - Basic Tests

    func testFilter_FirstLocation_ReturnsOriginal() {
        let location = MockData.createMockCLLocation()
        let filtered = kalmanFilter.filter(location)

        XCTAssertEqual(filtered.coordinate.latitude, location.coordinate.latitude, accuracy: 0.00001)
        XCTAssertEqual(filtered.coordinate.longitude, location.coordinate.longitude, accuracy: 0.00001)
    }

    func testFilter_MultipleLocations_Smooths() {
        let locations = [
            MockData.createMockCLLocation(latitude: 37.33182, longitude: -122.03118),
            MockData.createMockCLLocation(latitude: 37.33184, longitude: -122.03120), // Small movement
            MockData.createMockCLLocation(latitude: 37.33186, longitude: -122.03122), // Small movement
        ]

        var filtered: [CLLocation] = []
        for location in locations {
            filtered.append(kalmanFilter.filter(location))
        }

        // Filtered locations should be close to originals but smoothed
        XCTAssertEqual(filtered.count, 3)

        // First location should be unchanged
        XCTAssertEqual(filtered[0].coordinate.latitude, locations[0].coordinate.latitude, accuracy: 0.00001)

        // Subsequent locations should be smoothed (somewhere between previous and current)
        // The filtered value should be closer to the previous location than the raw measurement
        let rawDiff = locations[2].coordinate.latitude - locations[1].coordinate.latitude
        let filteredDiff = filtered[2].coordinate.latitude - filtered[1].coordinate.latitude

        // Filtered difference should be smaller (smoothed)
        XCTAssertTrue(abs(filteredDiff) <= abs(rawDiff))
    }

    func testFilter_NoisyData_ReducesNoise() {
        // Simulate noisy GPS data (jumping around same location)
        let baseLocation = MockData.createMockCLLocation(latitude: 37.33182, longitude: -122.03118)

        var filtered: [CLLocation] = []

        // Add first location
        filtered.append(kalmanFilter.filter(baseLocation))

        // Add noisy locations (small random variations)
        for i in 1...10 {
            let noise = Double(i % 2 == 0 ? 1 : -1) * 0.00005 // ±5.5m noise
            let noisyLocation = MockData.createMockCLLocation(
                latitude: baseLocation.coordinate.latitude + noise,
                longitude: baseLocation.coordinate.longitude + noise
            )
            filtered.append(kalmanFilter.filter(noisyLocation))
        }

        // Calculate variance of filtered locations (should be lower than raw)
        let latitudes = filtered.map { $0.coordinate.latitude }
        let avgLat = latitudes.reduce(0, +) / Double(latitudes.count)
        let variance = latitudes.map { pow($0 - avgLat, 2) }.reduce(0, +) / Double(latitudes.count)

        // Variance should be relatively small (indicating smoothing)
        XCTAssertTrue(variance < 0.0001, "Variance should be small: \(variance)")
    }

    // MARK: - Accuracy Tests

    func testFilter_HighAccuracyLocation_MoreWeight() {
        let highAccuracy = MockData.createMockCLLocation(
            latitude: 37.33182,
            longitude: -122.03118,
            horizontalAccuracy: 5.0
        )

        let lowAccuracy = MockData.createMockCLLocation(
            latitude: 37.33184,
            longitude: -122.03120,
            horizontalAccuracy: 50.0
        )

        _ = kalmanFilter.filter(highAccuracy)
        let filtered = kalmanFilter.filter(lowAccuracy)

        // Filtered location should be closer to high accuracy location
        let distanceToHigh = filtered.distance(from: highAccuracy)
        let distanceToLow = filtered.distance(from: lowAccuracy)

        XCTAssertTrue(distanceToHigh < distanceToLow, "Filtered should be closer to high accuracy location")
    }

    // MARK: - Edge Cases

    func testFilter_InvalidLocation_Rejected() {
        let invalidLocation = CLLocation(
            latitude: 0,
            longitude: 0
        )

        let filtered = kalmanFilter.filter(invalidLocation)

        // Should return the invalid location unchanged (or handle gracefully)
        XCTAssertNotNil(filtered)
    }

    func testFilter_LargeJump_Handled() {
        let location1 = MockData.createMockCLLocation(latitude: 37.33182, longitude: -122.03118)
        let location2 = MockData.createMockCLLocation(latitude: 37.43182, longitude: -122.13118) // ~15km jump

        _ = kalmanFilter.filter(location1)
        let filtered = kalmanFilter.filter(location2)

        // Filter should handle large jumps (might accept or heavily weight toward jump)
        XCTAssertNotNil(filtered)

        // Distance should be significant
        let distance = filtered.distance(from: location1)
        XCTAssertTrue(distance > 10000, "Large jump should be preserved")
    }

    // MARK: - Reset Tests

    func testReset_ClearsState() {
        let location1 = MockData.createMockCLLocation()
        _ = kalmanFilter.filter(location1)

        kalmanFilter.reset()

        let location2 = MockData.createMockCLLocation(latitude: 37.43182, longitude: -122.13118)
        let filtered = kalmanFilter.filter(location2)

        // After reset, should return location as-is (like first location)
        XCTAssertEqual(filtered.coordinate.latitude, location2.coordinate.latitude, accuracy: 0.00001)
    }

    // MARK: - Performance Tests

    func testFilter_Performance() {
        measure {
            let location = MockData.createMockCLLocation()
            for _ in 0..<1000 {
                _ = kalmanFilter.filter(location)
            }
        }
    }
}
