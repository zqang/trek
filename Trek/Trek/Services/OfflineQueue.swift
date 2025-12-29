//
//  OfflineQueue.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation

@MainActor
class OfflineQueue: ObservableObject {
    static let shared = OfflineQueue()

    @Published var pendingOperations: [QueuedOperation] = []
    @Published var isProcessing = false

    private let queueKey = "offlineQueue"

    private init() {
        loadQueue()
    }

    // MARK: - Queued Operation

    struct QueuedOperation: Codable, Identifiable {
        let id: String
        let type: OperationType
        let data: Data
        let timestamp: Date
        var retryCount: Int

        enum OperationType: String, Codable {
            case saveActivity
            case updateActivity
            case deleteActivity
            case updateProfile
        }

        init(id: String = UUID().uuidString, type: OperationType, data: Data, timestamp: Date = Date(), retryCount: Int = 0) {
            self.id = id
            self.type = type
            self.data = data
            self.timestamp = timestamp
            self.retryCount = retryCount
        }
    }

    // MARK: - Queue Management

    func enqueue(_ operation: QueuedOperation) {
        pendingOperations.append(operation)
        saveQueue()
    }

    func dequeue(_ operationId: String) {
        pendingOperations.removeAll { $0.id == operationId }
        saveQueue()
    }

    func incrementRetryCount(_ operationId: String) {
        if let index = pendingOperations.firstIndex(where: { $0.id == operationId }) {
            pendingOperations[index].retryCount += 1
            saveQueue()
        }
    }

    func clearQueue() {
        pendingOperations.removeAll()
        saveQueue()
    }

    // MARK: - Persistence

    private func saveQueue() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(pendingOperations)
            UserDefaults.standard.set(data, forKey: queueKey)
        } catch {
            print("Failed to save queue: \(error)")
        }
    }

    private func loadQueue() {
        guard let data = UserDefaults.standard.data(forKey: queueKey) else { return }

        do {
            let decoder = JSONDecoder()
            pendingOperations = try decoder.decode([QueuedOperation].self, from: data)
        } catch {
            print("Failed to load queue: \(error)")
        }
    }

    // MARK: - Queue Activity

    func queueActivity(_ activity: Activity, operation: QueuedOperation.OperationType) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(activity)
            let queuedOp = QueuedOperation(type: operation, data: data)
            enqueue(queuedOp)
        } catch {
            print("Failed to queue activity: \(error)")
        }
    }

    func queueActivityUpdate(_ activity: Activity) {
        queueActivity(activity, operation: .updateActivity)
    }

    func queueActivityDelete(activityId: String, userId: String) {
        let deleteData = ActivityDeleteData(activityId: activityId, userId: userId)
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(deleteData)
            let queuedOp = QueuedOperation(type: .deleteActivity, data: data)
            enqueue(queuedOp)
        } catch {
            print("Failed to queue delete: \(error)")
        }
    }

    // MARK: - Helper Structs

    struct ActivityDeleteData: Codable {
        let activityId: String
        let userId: String
    }

    // MARK: - Queue Stats

    var queueCount: Int {
        pendingOperations.count
    }

    var hasQueuedOperations: Bool {
        !pendingOperations.isEmpty
    }

    var oldestOperation: QueuedOperation? {
        pendingOperations.min(by: { $0.timestamp < $1.timestamp })
    }

    func operationsByType(_ type: QueuedOperation.OperationType) -> [QueuedOperation] {
        pendingOperations.filter { $0.type == type }
    }
}
