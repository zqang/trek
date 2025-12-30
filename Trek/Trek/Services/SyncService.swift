//
//  SyncService.swift
//  Trek
//
//  Note: With local Core Data storage, this service is no longer needed
//  but kept as a stub for potential future cloud sync features.
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

    private init() {}

    var syncStatusMessage: String {
        "All data stored locally"
    }

    var pendingOperationsCount: Int { 0 }
    var hasPendingOperations: Bool { false }

    func manualSync() async {
        // No-op for local storage
    }
}
