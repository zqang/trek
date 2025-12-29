//
//  SyncService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Combine

@MainActor
class SyncService: ObservableObject {
    static let shared = SyncService()

    @Published var isSyncing = false
    @Published var syncProgress: Double = 0
    @Published var lastSyncDate: Date?
    @Published var syncError: String?

    private let networkMonitor = NetworkMonitor.shared
    private let offlineQueue = OfflineQueue.shared
    private let activityService = ActivityService()

    private var cancellables = Set<AnyCancellable>()
    private let maxRetries = 3

    private init() {
        setupNetworkObserver()
        loadLastSyncDate()
    }

    // MARK: - Setup

    private func setupNetworkObserver() {
        // Listen for network connection
        NotificationCenter.default.publisher(for: .networkConnected)
            .sink { [weak self] _ in
                Task {
                    await self?.syncPendingOperations()
                }
            }
            .store(in: &cancellables)
    }

    private func loadLastSyncDate() {
        if let timestamp = UserDefaults.standard.object(forKey: "lastSyncDate") as? Date {
            lastSyncDate = timestamp
        }
    }

    private func saveLastSyncDate() {
        lastSyncDate = Date()
        UserDefaults.standard.set(lastSyncDate, forKey: "lastSyncDate")
    }

    // MARK: - Sync Operations

    func syncPendingOperations() async {
        guard !isSyncing else { return }
        guard networkMonitor.isConnected else {
            print("Cannot sync: No network connection")
            return
        }
        guard offlineQueue.hasQueuedOperations else {
            print("No pending operations to sync")
            return
        }

        isSyncing = true
        syncProgress = 0
        syncError = nil

        let operations = offlineQueue.pendingOperations
        let totalOperations = Double(operations.count)

        for (index, operation) in operations.enumerated() {
            do {
                try await processOperation(operation)
                offlineQueue.dequeue(operation.id)

                syncProgress = Double(index + 1) / totalOperations
            } catch {
                print("Failed to process operation \(operation.id): \(error)")

                // Increment retry count
                offlineQueue.incrementRetryCount(operation.id)

                // Remove if max retries exceeded
                if operation.retryCount >= maxRetries {
                    print("Max retries exceeded for operation \(operation.id), removing from queue")
                    offlineQueue.dequeue(operation.id)
                    syncError = "Some operations failed to sync"
                }
            }
        }

        saveLastSyncDate()
        isSyncing = false
        syncProgress = 1.0

        // Reset progress after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.syncProgress = 0
        }
    }

    // MARK: - Process Individual Operation

    private func processOperation(_ operation: OfflineQueue.QueuedOperation) async throws {
        switch operation.type {
        case .saveActivity:
            try await processSaveActivity(operation)

        case .updateActivity:
            try await processUpdateActivity(operation)

        case .deleteActivity:
            try await processDeleteActivity(operation)

        case .updateProfile:
            // TODO: Implement profile update sync
            break
        }
    }

    private func processSaveActivity(_ operation: OfflineQueue.QueuedOperation) async throws {
        let decoder = JSONDecoder()
        let activity = try decoder.decode(Activity.self, from: operation.data)
        _ = try await activityService.saveActivity(activity)
    }

    private func processUpdateActivity(_ operation: OfflineQueue.QueuedOperation) async throws {
        let decoder = JSONDecoder()
        let activity = try decoder.decode(Activity.self, from: operation.data)
        try await activityService.updateActivity(activity)
    }

    private func processDeleteActivity(_ operation: OfflineQueue.QueuedOperation) async throws {
        let decoder = JSONDecoder()
        let deleteData = try decoder.decode(OfflineQueue.ActivityDeleteData.self, from: operation.data)
        try await activityService.deleteActivity(id: deleteData.activityId, userId: deleteData.userId)
    }

    // MARK: - Manual Sync

    func manualSync() async {
        await syncPendingOperations()
    }

    // MARK: - Sync Status

    var syncStatusMessage: String {
        if isSyncing {
            return "Syncing \(Int(syncProgress * 100))%..."
        } else if let lastSync = lastSyncDate {
            return "Last synced: \(lastSync.formatted(.relative(presentation: .named)))"
        } else {
            return "Never synced"
        }
    }

    var pendingOperationsCount: Int {
        offlineQueue.queueCount
    }

    var hasPendingOperations: Bool {
        offlineQueue.hasQueuedOperations
    }
}
