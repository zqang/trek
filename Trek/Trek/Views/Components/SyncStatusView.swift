//
//  SyncStatusView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct SyncStatusView: View {
    @ObservedObject var syncService = SyncService.shared
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    @ObservedObject var offlineQueue = OfflineQueue.shared

    var body: some View {
        NavigationView {
            List {
                // Network Status Section
                Section(header: Text("Network Status")) {
                    HStack {
                        Image(systemName: networkMonitor.connectionType.icon)
                            .foregroundColor(networkMonitor.isConnected ? .green : .red)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(networkMonitor.isConnected ? "Connected" : "Disconnected")
                                .font(.headline)

                            Text(networkMonitor.statusMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Circle()
                            .fill(networkMonitor.isConnected ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                    }
                    .padding(.vertical, 8)
                }

                // Sync Status Section
                Section(header: Text("Sync Status")) {
                    if syncService.isSyncing {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Syncing...")
                                    .font(.headline)

                                Spacer()

                                ProgressView()
                            }

                            ProgressView(value: syncService.syncProgress, total: 1.0)
                                .progressViewStyle(LinearProgressViewStyle())

                            Text("\(Int(syncService.syncProgress * 100))% complete")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    } else {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Sync Complete")
                                    .font(.headline)

                                if let lastSync = syncService.lastSyncDate {
                                    Text("Last synced: \(lastSync.formatted(.relative(presentation: .named)))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                } else {
                                    Text("Never synced")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }

                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }

                    // Manual Sync Button
                    if networkMonitor.isConnected && !syncService.isSyncing {
                        Button(action: {
                            Task {
                                await syncService.manualSync()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Sync Now")
                            }
                        }
                    }
                }

                // Pending Operations Section
                if offlineQueue.hasQueuedOperations {
                    Section(header: Text("Pending Operations")) {
                        Text("\(offlineQueue.queueCount) operations waiting to sync")
                            .font(.subheadline)

                        ForEach(offlineQueue.pendingOperations) { operation in
                            OperationRow(operation: operation)
                        }
                    }
                }

                // Info Section
                Section(header: Text("About Offline Mode")) {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(
                            icon: "checkmark.circle",
                            title: "Activities are saved locally",
                            description: "Your recorded activities are always saved to your device first."
                        )

                        InfoRow(
                            icon: "arrow.triangle.2.circlepath",
                            title: "Automatic sync when online",
                            description: "Pending changes sync automatically when you're back online."
                        )

                        InfoRow(
                            icon: "exclamationmark.triangle",
                            title: "Retry logic",
                            description: "Failed operations are retried up to 3 times before being removed."
                        )
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Sync Status")
        }
    }
}

// MARK: - Operation Row
struct OperationRow: View {
    let operation: OfflineQueue.QueuedOperation

    var body: some View {
        HStack {
            Image(systemName: operationIcon)
                .foregroundColor(.accentColor)
                .frame(width: 25)

            VStack(alignment: .leading, spacing: 4) {
                Text(operationTitle)
                    .font(.subheadline)

                Text(operation.timestamp.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if operation.retryCount > 0 {
                Text("\(operation.retryCount) retries")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 4)
    }

    private var operationIcon: String {
        switch operation.type {
        case .saveActivity:
            return "plus.circle"
        case .updateActivity:
            return "pencil.circle"
        case .deleteActivity:
            return "trash.circle"
        case .updateProfile:
            return "person.circle"
        }
    }

    private var operationTitle: String {
        switch operation.type {
        case .saveActivity:
            return "Save Activity"
        case .updateActivity:
            return "Update Activity"
        case .deleteActivity:
            return "Delete Activity"
        case .updateProfile:
            return "Update Profile"
        }
    }
}

// MARK: - Info Row
struct InfoRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .frame(width: 25)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SyncStatusView()
}
