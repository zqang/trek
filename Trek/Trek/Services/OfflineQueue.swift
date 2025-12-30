//
//  OfflineQueue.swift
//  Trek
//
//  Note: With local Core Data storage, this service is no longer needed
//  but kept as a stub for potential future cloud sync features.
//

import Foundation

@MainActor
class OfflineQueue: ObservableObject {
    static let shared = OfflineQueue()

    @Published var pendingOperations: [QueuedOperation] = []
    @Published var isProcessing = false

    private init() {}

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
    }

    var queueCount: Int { 0 }
    var hasQueuedOperations: Bool { false }

    func clearQueue() {
        pendingOperations.removeAll()
    }
}
