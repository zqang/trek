//
//  CoreDataStack.swift
//  Trek
//
//  Local JSON-based persistence for users and activities.
//

import Foundation
import os.log

private let logger = Logger(subsystem: "com.trek", category: "CoreDataStack")

class CoreDataStack {
    static let shared = CoreDataStack()

    private let fileManager = FileManager.default
    private let usersFileName = "users.json"
    private let activitiesFileName = "activities.json"

    private var dataDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("TrekData")
    }

    // Shared context for consistent state
    private var _viewContext: LocalContext?

    private init() {
        do {
            try fileManager.createDirectory(at: dataDirectory, withIntermediateDirectories: true)
        } catch {
            logger.error("Failed to create data directory: \(error.localizedDescription)")
        }
    }

    // MARK: - Simulated Core Data context (singleton for consistency)
    var viewContext: LocalContext {
        if _viewContext == nil {
            _viewContext = LocalContext(stack: self)
        }
        return _viewContext!
    }

    func saveContext() {
        // Auto-saved in LocalContext
    }

    // Reload context from disk (useful after external changes)
    func reloadContext() {
        _viewContext = LocalContext(stack: self)
    }

    // MARK: - File URLs
    private var usersFileURL: URL {
        dataDirectory.appendingPathComponent(usersFileName)
    }

    private var activitiesFileURL: URL {
        dataDirectory.appendingPathComponent(activitiesFileName)
    }

    // MARK: - Users
    func loadUsers() -> [UserEntity] {
        do {
            let data = try Data(contentsOf: usersFileURL)
            let users = try JSONDecoder().decode([UserEntity].self, from: data)
            return users
        } catch {
            // File not found is expected on first run
            if (error as NSError).code != NSFileReadNoSuchFileError {
                logger.error("Failed to load users: \(error.localizedDescription)")
            }
            return []
        }
    }

    func saveUsers(_ users: [UserEntity]) {
        do {
            let data = try JSONEncoder().encode(users)
            try data.write(to: usersFileURL)
        } catch {
            logger.error("Failed to save users: \(error.localizedDescription)")
        }
    }

    // MARK: - Activities
    func loadActivities() -> [ActivityEntity] {
        do {
            let data = try Data(contentsOf: activitiesFileURL)
            let activities = try JSONDecoder().decode([ActivityEntity].self, from: data)
            return activities
        } catch {
            // File not found is expected on first run
            if (error as NSError).code != NSFileReadNoSuchFileError {
                logger.error("Failed to load activities: \(error.localizedDescription)")
            }
            return []
        }
    }

    func saveActivities(_ activities: [ActivityEntity]) {
        do {
            let data = try JSONEncoder().encode(activities)
            try data.write(to: activitiesFileURL)
        } catch {
            logger.error("Failed to save activities: \(error.localizedDescription)")
        }
    }
}

// MARK: - Local Context (simulates NSManagedObjectContext)
class LocalContext {
    private let stack: CoreDataStack
    private var users: [UserEntity]
    private var activities: [ActivityEntity]
    private var pendingUserDeletions: [UserEntity] = []
    private var pendingActivityDeletions: [ActivityEntity] = []

    init(stack: CoreDataStack) {
        self.stack = stack
        self.users = stack.loadUsers()
        self.activities = stack.loadActivities()
    }

    func fetch<T>(_ request: LocalFetchRequest<T>) throws -> [T] {
        if T.self == UserEntity.self {
            var result = applyPredicate(request.predicate, to: users) as! [T]
            if request.fetchLimit > 0 {
                result = Array(result.prefix(request.fetchLimit))
            }
            return result
        } else if T.self == ActivityEntity.self {
            var result = applyPredicate(request.predicate, to: activities) as! [T]

            // Apply sorting if needed
            if let sortDescriptors = request.localSortDescriptors {
                for descriptor in sortDescriptors.reversed() {
                    if descriptor.key == "startTime" {
                        result = (result as! [ActivityEntity]).sorted {
                            guard let d1 = $0.startTime, let d2 = $1.startTime else { return false }
                            return descriptor.ascending ? d1 < d2 : d1 > d2
                        } as! [T]
                    }
                }
            }

            // Apply offset and limit
            if request.fetchOffset > 0 {
                result = Array(result.dropFirst(request.fetchOffset))
            }
            if request.fetchLimit > 0 {
                result = Array(result.prefix(request.fetchLimit))
            }
            return result
        }
        return []
    }

    private func applyPredicate<T: EntityProtocol>(_ predicate: NSPredicate?, to items: [T]) -> [T] {
        guard let predicate = predicate else { return items }
        return items.filter { predicate.evaluate(with: $0.toDictionary()) }
    }

    func delete(_ object: Any) {
        if let user = object as? UserEntity {
            pendingUserDeletions.append(user)
        } else if let activity = object as? ActivityEntity {
            pendingActivityDeletions.append(activity)
        }
    }

    func save() throws {
        // Apply deletions
        for user in pendingUserDeletions {
            users.removeAll { $0.id == user.id }
        }
        for activity in pendingActivityDeletions {
            activities.removeAll { $0.id == activity.id }
        }
        pendingUserDeletions.removeAll()
        pendingActivityDeletions.removeAll()

        stack.saveUsers(users)
        stack.saveActivities(activities)
    }

    func addUser(_ user: UserEntity) {
        users.append(user)
    }

    func addActivity(_ activity: ActivityEntity) {
        activities.append(activity)
    }

    func updateUser(_ user: UserEntity) {
        if let index = users.firstIndex(where: { $0.id == user.id }) {
            users[index] = user
        }
    }

    func updateActivity(_ activity: ActivityEntity) {
        if let index = activities.firstIndex(where: { $0.id == activity.id }) {
            activities[index] = activity
        }
    }

    func deleteActivity(_ activity: ActivityEntity) {
        activities.removeAll { $0.id == activity.id }
    }

    func deleteUser(_ user: UserEntity) {
        users.removeAll { $0.id == user.id }
    }
}

// MARK: - Entity Protocol
protocol EntityProtocol {
    func toDictionary() -> [String: Any]
}

// MARK: - UserEntity
class UserEntity: Codable, EntityProtocol {
    var id: UUID?
    var email: String?
    var name: String?
    var bio: String?
    var profilePhotoPath: String?
    var totalDistance: Double = 0
    var totalActivities: Int32 = 0
    var totalDuration: Double = 0
    var preferredUnits: String? = "metric"
    var createdAt: Date?

    init() {}

    func toDictionary() -> [String: Any] {
        [
            "id": id as Any,
            "email": email as Any,
            "name": name as Any
        ]
    }
}

// MARK: - ActivityEntity
class ActivityEntity: Codable, EntityProtocol {
    var id: UUID?
    var userId: UUID?
    var name: String?
    var type: String? = "run"
    var startTime: Date?
    var endTime: Date?
    var distance: Double = 0
    var duration: Double = 0
    var elevationGain: Double = 0
    var routeData: Data?
    var calories: Double = 0
    var activityDescription: String?
    var averageHeartRate: Double = 0
    var maxHeartRate: Double = 0

    init() {}

    func toDictionary() -> [String: Any] {
        [
            "id": id as Any,
            "userId": userId as Any,
            "type": type as Any,
            "startTime": startTime as Any
        ]
    }
}

// MARK: - LocalSortDescriptor (replacement for NSSortDescriptor)
struct LocalSortDescriptor {
    let key: String
    let ascending: Bool

    init(key: String, ascending: Bool = true) {
        self.key = key
        self.ascending = ascending
    }
}

// MARK: - LocalFetchRequest (simplified fetch request)
class LocalFetchRequest<T> {
    var predicate: NSPredicate?
    var localSortDescriptors: [LocalSortDescriptor]?
    var fetchLimit: Int = 0
    var fetchOffset: Int = 0

    init() {}

    // Convenience property to accept NSSortDescriptor and convert
    var sortDescriptors: [NSSortDescriptor]? {
        get { nil }
        set {
            localSortDescriptors = newValue?.compactMap { descriptor in
                guard let key = descriptor.key else { return nil }
                return LocalSortDescriptor(key: key, ascending: descriptor.ascending)
            }
        }
    }
}

extension UserEntity {
    static func fetchRequest() -> LocalFetchRequest<UserEntity> {
        return LocalFetchRequest<UserEntity>()
    }
}

extension ActivityEntity {
    static func fetchRequest() -> LocalFetchRequest<ActivityEntity> {
        return LocalFetchRequest<ActivityEntity>()
    }
}
