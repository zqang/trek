//
//  ActivityService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ActivityService {
    private let db = Firestore.firestore()

    // MARK: - Create Activity
    func saveActivity(_ activity: Activity) async throws -> String {
        let docRef = try db.collection("activities").addDocument(from: activity)

        // Update user stats
        try await updateUserStats(userId: activity.userId, activity: activity)

        return docRef.documentID
    }

    // MARK: - Read Activities
    func fetchActivities(userId: String, limit: Int = 20) async throws -> [Activity] {
        let snapshot = try await db.collection("activities")
            .whereField("userId", isEqualTo: userId)
            .order(by: "startTime", descending: true)
            .limit(to: limit)
            .getDocuments()

        return try snapshot.documents.compactMap { doc in
            try doc.data(as: Activity.self)
        }
    }

    func fetchActivity(id: String) async throws -> Activity {
        let document = try await db.collection("activities").document(id).getDocument()
        return try document.data(as: Activity.self)
    }

    // MARK: - Update Activity
    func updateActivity(_ activity: Activity) async throws {
        guard let activityId = activity.id else {
            throw ActivityServiceError.missingActivityId
        }

        try db.collection("activities")
            .document(activityId)
            .setData(from: activity, merge: true)
    }

    // MARK: - Delete Activity
    func deleteActivity(id: String, userId: String) async throws {
        // Fetch activity first to get stats for user update
        let activity = try await fetchActivity(id: id)

        // Delete the activity
        try await db.collection("activities").document(id).delete()

        // Update user stats (subtract this activity's stats)
        try await decrementUserStats(userId: userId, activity: activity)
    }

    // MARK: - User Stats Management
    private func updateUserStats(userId: String, activity: Activity) async throws {
        let userRef = db.collection("users").document(userId)

        try await userRef.updateData([
            "totalDistance": FieldValue.increment(activity.distance),
            "totalActivities": FieldValue.increment(Int64(1)),
            "totalDuration": FieldValue.increment(activity.duration)
        ])
    }

    private func decrementUserStats(userId: String, activity: Activity) async throws {
        let userRef = db.collection("users").document(userId)

        try await userRef.updateData([
            "totalDistance": FieldValue.increment(-activity.distance),
            "totalActivities": FieldValue.increment(Int64(-1)),
            "totalDuration": FieldValue.increment(-activity.duration)
        ])
    }

    // MARK: - Export Activity as GPX
    func exportActivityAsGPX(_ activity: Activity) -> String {
        var gpx = """
        <?xml version="1.0" encoding="UTF-8"?>
        <gpx version="1.1" creator="Trek">
          <metadata>
            <name>\(activity.displayName)</name>
            <time>\(ISO8601DateFormatter().string(from: activity.startTime))</time>
          </metadata>
          <trk>
            <name>\(activity.displayName)</name>
            <type>\(activity.type.displayName)</type>
            <trkseg>

        """

        for point in activity.route {
            let timestamp = ISO8601DateFormatter().string(from: point.timestamp)
            gpx += """
                  <trkpt lat="\(point.latitude)" lon="\(point.longitude)">
                    <ele>\(point.altitude)</ele>
                    <time>\(timestamp)</time>
                  </trkpt>

            """
        }

        gpx += """
            </trkseg>
          </trk>
        </gpx>
        """

        return gpx
    }

    // MARK: - Statistics
    func fetchUserStats(userId: String, startDate: Date, endDate: Date) async throws -> UserStats {
        let snapshot = try await db.collection("activities")
            .whereField("userId", isEqualTo: userId)
            .whereField("startTime", isGreaterThanOrEqualTo: startDate)
            .whereField("startTime", isLessThanOrEqualTo: endDate)
            .getDocuments()

        let activities = try snapshot.documents.compactMap { doc in
            try doc.data(as: Activity.self)
        }

        let totalDistance = activities.reduce(0) { $0 + $1.distance }
        let totalDuration = activities.reduce(0) { $0 + $1.duration }
        let totalElevation = activities.reduce(0) { $0 + $1.elevationGain }

        return UserStats(
            totalActivities: activities.count,
            totalDistance: totalDistance,
            totalDuration: totalDuration,
            totalElevation: totalElevation,
            activities: activities
        )
    }
}

// MARK: - Activity Service Errors
enum ActivityServiceError: LocalizedError {
    case missingActivityId
    case saveFailed
    case fetchFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .missingActivityId:
            return "Activity is missing an ID"
        case .saveFailed:
            return "Failed to save activity"
        case .fetchFailed:
            return "Failed to fetch activities"
        case .deleteFailed:
            return "Failed to delete activity"
        }
    }
}

// MARK: - User Stats
struct UserStats {
    let totalActivities: Int
    let totalDistance: Double
    let totalDuration: TimeInterval
    let totalElevation: Double
    let activities: [Activity]
}
