//
//  NetworkStatusBanner.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct NetworkStatusBanner: View {
    @ObservedObject var networkMonitor = NetworkMonitor.shared
    @ObservedObject var syncService = SyncService.shared

    @State private var showBanner = false

    var body: some View {
        VStack(spacing: 0) {
            if showBanner {
                banner
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showBanner)
        .onChange(of: networkMonitor.isConnected) { isConnected in
            withAnimation {
                showBanner = !isConnected || syncService.isSyncing
            }

            // Auto-hide after 3 seconds if connected
            if isConnected && !syncService.isSyncing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showBanner = false
                    }
                }
            }
        }
        .onChange(of: syncService.isSyncing) { isSyncing in
            withAnimation {
                showBanner = isSyncing || !networkMonitor.isConnected
            }

            // Auto-hide after sync completes
            if !isSyncing && networkMonitor.isConnected {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showBanner = false
                    }
                }
            }
        }
        .onAppear {
            // Show banner initially if offline
            showBanner = !networkMonitor.isConnected
        }
    }

    private var banner: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: bannerIcon)
                .font(.headline)
                .foregroundColor(bannerForegroundColor)

            // Message
            VStack(alignment: .leading, spacing: 2) {
                Text(bannerTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(bannerForegroundColor)

                if let subtitle = bannerSubtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(bannerForegroundColor.opacity(0.9))
                }
            }

            Spacer()

            // Progress or Action
            if syncService.isSyncing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: bannerForegroundColor))
                    .scaleEffect(0.8)
            } else if syncService.hasPendingOperations && networkMonitor.isConnected {
                Button(action: {
                    Task {
                        await syncService.manualSync()
                    }
                }) {
                    Text("Sync")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(bannerBackgroundColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(bannerForegroundColor)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(bannerBackgroundColor)
    }

    // MARK: - Banner Properties

    private var bannerIcon: String {
        if syncService.isSyncing {
            return "arrow.triangle.2.circlepath"
        } else if !networkMonitor.isConnected {
            return "wifi.slash"
        } else if syncService.hasPendingOperations {
            return "exclamationmark.triangle"
        } else {
            return "checkmark.circle"
        }
    }

    private var bannerTitle: String {
        if syncService.isSyncing {
            return "Syncing..."
        } else if !networkMonitor.isConnected {
            return "No Internet Connection"
        } else if syncService.hasPendingOperations {
            return "Changes Not Synced"
        } else {
            return "Back Online"
        }
    }

    private var bannerSubtitle: String? {
        if syncService.isSyncing {
            return "\(Int(syncService.syncProgress * 100))% complete"
        } else if !networkMonitor.isConnected {
            return "Your data will sync when reconnected"
        } else if syncService.hasPendingOperations {
            return "\(syncService.pendingOperationsCount) pending operations"
        } else {
            return nil
        }
    }

    private var bannerBackgroundColor: Color {
        if syncService.isSyncing {
            return .blue
        } else if !networkMonitor.isConnected {
            return .red
        } else if syncService.hasPendingOperations {
            return .orange
        } else {
            return .green
        }
    }

    private var bannerForegroundColor: Color {
        return .white
    }
}

#Preview {
    VStack {
        NetworkStatusBanner()
        Spacer()
    }
}
