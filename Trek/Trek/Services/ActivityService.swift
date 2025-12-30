//
//  ActivityService.swift
//  Trek
//
//  Local activity service using JSON-based storage.
//

import Foundation

@MainActor
class ActivityService {
    private let coreData = CoreDataStack.shared

    // MARK: - Create Activity
    func saveActivity(_ activity: Activity) async throws -> String {
        let context = coreData.viewContext

        let entity = ActivityEntity()
        let activityId = UUID()
        entity.id = activityId
        entity.userId = UUID(uuidString: activity.userId)
        entity.name = activity.name
        entity.type = activity.type.rawValue
        entity.startTime = activity.startTime
        entity.endTime = activity.endTime
        entity.distance = activity.distance
        entity.duration = activity.duration
        entity.elevationGain = activity.elevationGain
        entity.calories = 0
        entity.activityDescription = nil

        // Encode route as binary data
        if !activity.route.isEmpty {
            entity.routeData = try? JSONEncoder().encode(activity.route)
        }

        context.addActivity(entity)
        try context.save()

        // Update user stats
        try await updateUserStats(userId: activity.userId, activity: activity)

        return activityId.uuidString
    }

    // MARK: - Read Activities
    func fetchActivities(userId: String, limit: Int = 20, offset: Int = 0) async throws -> [Activity] {
        guard let uuid = UUID(uuidString: userId) else { return [] }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", uuid as CVarArg)
        request.localSortDescriptors = [LocalSortDescriptor(key: "startTime", ascending: false)]
        request.fetchLimit = limit
        request.fetchOffset = offset

        let entities = try context.fetch(request)
        return entities.map { Activity(entity: $0) }
    }

    func fetchActivity(id: String) async throws -> Activity {
        guard let uuid = UUID(uuidString: id) else {
            throw ActivityServiceError.fetchFailed
        }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        request.fetchLimit = 1

        guard let entity = try context.fetch(request).first else {
            throw ActivityServiceError.fetchFailed
        }

        return Activity(entity: entity)
    }

    // MARK: - Update Activity
    func updateActivity(_ activity: Activity) async throws {
        guard let activityId = activity.id,
              let uuid = UUID(uuidString: activityId) else {
            throw ActivityServiceError.missingActivityId
        }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        guard let entity = try context.fetch(request).first else {
            throw ActivityServiceError.fetchFailed
        }

        entity.name = activity.name
        entity.type = activity.type.rawValue
        entity.activityDescription = nil

        context.updateActivity(entity)
        try context.save()
    }

    // MARK: - Delete Activity
    func deleteActivity(id: String, userId: String) async throws {
        guard let uuid = UUID(uuidString: id) else {
            throw ActivityServiceError.deleteFailed
        }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        guard let entity = try context.fetch(request).first else {
            throw ActivityServiceError.fetchFailed
        }

        // Get activity data before deleting for stats update
        let activity = Activity(entity: entity)

        context.deleteActivity(entity)
        try context.save()

        // Update user stats
        try await decrementUserStats(userId: userId, activity: activity)
    }

    // MARK: - User Stats Management
    private func updateUserStats(userId: String, activity: Activity) async throws {
        guard let uuid = UUID(uuidString: userId) else { return }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        guard let userEntity = try context.fetch(request).first else { return }

        userEntity.totalDistance += activity.distance
        userEntity.totalActivities += 1
        userEntity.totalDuration += activity.duration

        context.updateUser(userEntity)
        try context.save()
    }

    private func decrementUserStats(userId: String, activity: Activity) async throws {
        guard let uuid = UUID(uuidString: userId) else { return }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        guard let userEntity = try context.fetch(request).first else { return }

        userEntity.totalDistance = max(0, userEntity.totalDistance - activity.distance)
        userEntity.totalActivities = max(0, userEntity.totalActivities - 1)
        userEntity.totalDuration = max(0, userEntity.totalDuration - activity.duration)

        context.updateUser(userEntity)
        try context.save()
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
        guard let uuid = UUID(uuidString: userId) else {
            return UserStats(totalActivities: 0, totalDistance: 0, totalDuration: 0, totalElevation: 0, activities: [])
        }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(
            format: "userId == %@ AND startTime >= %@ AND startTime <= %@",
            uuid as CVarArg, startDate as CVarArg, endDate as CVarArg
        )
        request.localSortDescriptors = [LocalSortDescriptor(key: "startTime", ascending: false)]

        let entities = try context.fetch(request)
        let activities = entities.map { Activity(entity: $0) }

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

    // MARK: - Fetch All Activities for Export
    func fetchAllActivities(userId: String) async throws -> [Activity] {
        guard let uuid = UUID(uuidString: userId) else { return [] }

        let context = coreData.viewContext
        let request = ActivityEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", uuid as CVarArg)
        request.localSortDescriptors = [LocalSortDescriptor(key: "startTime", ascending: false)]

        let entities = try context.fetch(request)
        return entities.map { Activity(entity: $0) }
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
