//
//  TestHelpers.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import XCTest
import CoreLocation
@testable import Trek

// MARK: - Mock Data

enum MockData {
    // MARK: - User
    static func createMockUser(
        id: String = "test_user_123",
        email: String = "test@example.com",
        displayName: String? = "Test User",
        photoURL: String? = nil,
        bio: String? = "Test bio"
    ) -> User {
        User(
            id: id,
            email: email,
            displayName: displayName,
            photoURL: photoURL,
            bio: bio,
            createdAt: Date()
        )
    }

    // MARK: - Activity
    static func createMockActivity(
        id: String? = "activity_123",
        userId: String = "test_user_123",
        name: String = "Morning Run",
        type: ActivityType = .run,
        distance: Double = 5000,
        duration: TimeInterval = 1800,
        elevationGain: Double = 50
    ) -> Activity {
        Activity(
            id: id,
            userId: userId,
            name: name,
            type: type,
            startTime: Date().addingTimeInterval(-duration),
            endTime: Date(),
            distance: distance,
            duration: duration,
            elevationGain: elevationGain,
            route: createMockRoute(),
            splits: createMockSplits(),
            isPrivate: false,
            createdAt: Date()
        )
    }

    // MARK: - Location Points
    static func createMockRoute(count: Int = 100) -> [LocationPoint] {
        var route: [LocationPoint] = []
        let startLat = 37.33182
        let startLon = -122.03118

        for i in 0..<count {
            let point = LocationPoint(
                latitude: startLat + Double(i) * 0.0001,
                longitude: startLon + Double(i) * 0.0001,
                altitude: 20.0 + Double(i) * 0.1,
                timestamp: Date().addingTimeInterval(Double(i) * 10),
                speed: 2.5,
                horizontalAccuracy: 10.0
            )
            route.append(point)
        }

        return route
    }

    // MARK: - Splits
    static func createMockSplits(count: Int = 5) -> [Split] {
        var splits: [Split] = []

        for i in 0..<count {
            let split = Split(
                index: i + 1,
                distance: 1000,
                duration: 360 + Double(i) * 5,
                pace: 360 + Double(i) * 5
            )
            splits.append(split)
        }

        return splits
    }

    // MARK: - Activity Stats
    static func createMockStats() -> ActivityStats {
        ActivityStats(
            distance: 5000,
            duration: 1800,
            pace: 360,
            speed: 2.77,
            elevationGain: 50,
            splits: createMockSplits()
        )
    }

    // MARK: - CLLocation
    static func createMockCLLocation(
        latitude: Double = 37.33182,
        longitude: Double = -122.03118,
        altitude: Double = 20.0,
        horizontalAccuracy: Double = 10.0
    ) -> CLLocation {
        CLLocation(
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: 5.0,
            timestamp: Date()
        )
    }
}

// MARK: - Test Extensions

extension XCTestCase {
    /// Wait for async operation with timeout
    func waitForAsync(timeout: TimeInterval = 2.0, completion: @escaping () async throws -> Void) {
        let expectation = expectation(description: "Async operation")

        Task {
            do {
                try await completion()
                expectation.fulfill()
            } catch {
                XCTFail("Async operation failed: \(error)")
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: timeout)
    }

    /// Assert no throw with async
    func XCTAssertNoThrowAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
        } catch {
            XCTFail("Unexpected error: \(error) - \(message)", file: file, line: line)
        }
    }

    /// Assert throws with async
    func XCTAssertThrowsErrorAsync<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        errorHandler: ((Error) -> Void)? = nil
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error to be thrown - \(message)", file: file, line: line)
        } catch {
            errorHandler?(error)
        }
    }
}

// MARK: - Assertions

extension XCTestCase {
    /// Assert two doubles are approximately equal
    func XCTAssertApproximatelyEqual(
        _ value1: Double,
        _ value2: Double,
        accuracy: Double = 0.01,
        _ message: String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(value1, value2, accuracy: accuracy, message, file: file, line: line)
    }

    /// Assert activity properties
    func XCTAssertActivity(
        _ activity: Activity,
        hasDistance distance: Double,
        duration: TimeInterval,
        type: ActivityType,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertApproximatelyEqual(activity.distance, distance, file: file, line: line)
        XCTAssertApproximatelyEqual(activity.duration, duration, file: file, line: line)
        XCTAssertEqual(activity.type, type, file: file, line: line)
    }
}
