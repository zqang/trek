//
//  MockActivityService.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import Foundation
@testable import Trek

@MainActor
class MockActivityService {
    var savedActivities: [Activity] = []
    var shouldThrowError = false
    var saveActivityCalled = false
    var updateActivityCalled = false
    var deleteActivityCalled = false

    func saveActivity(_ activity: Activity) async throws -> String {
        saveActivityCalled = true

        if shouldThrowError {
            throw ActivityServiceError.saveFailed
        }

        var activityWithId = activity
        activityWithId.id = "mock_activity_\(UUID().uuidString)"
        savedActivities.append(activityWithId)

        return activityWithId.id!
    }

    func fetchActivities(userId: String, limit: Int = 20) async throws -> [Activity] {
        if shouldThrowError {
            throw ActivityServiceError.fetchFailed
        }

        return savedActivities.filter { $0.userId == userId }
    }

    func updateActivity(_ activity: Activity) async throws {
        updateActivityCalled = true

        if shouldThrowError {
            throw ActivityServiceError.saveFailed
        }

        if let index = savedActivities.firstIndex(where: { $0.id == activity.id }) {
            savedActivities[index] = activity
        }
    }

    func deleteActivity(id: String, userId: String) async throws {
        deleteActivityCalled = true

        if shouldThrowError {
            throw ActivityServiceError.deleteFailed
        }

        savedActivities.removeAll { $0.id == id }
    }

    func exportActivityAsGPX(_ activity: Activity) -> String {
        return "<gpx>Mock GPX</gpx>"
    }

    // Test helpers
    func reset() {
        savedActivities = []
        shouldThrowError = false
        saveActivityCalled = false
        updateActivityCalled = false
        deleteActivityCalled = false
    }
}
