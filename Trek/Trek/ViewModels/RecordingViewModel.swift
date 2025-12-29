//
//  RecordingViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Combine

@MainActor
class RecordingViewModel: ObservableObject {
    @Published var selectedActivityType: ActivityType = .run
    @Published var showActivitySummary = false
    @Published var showRecoveryAlert = false
    @Published var completedStats: ActivityStats?
    @Published var completedRoute: [LocationPoint] = []

    private let crashRecoveryService = CrashRecoveryService()
    private var autoSaveTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    let locationService: LocationService

    init(locationService: LocationService) {
        self.locationService = locationService

        // Check for pending recording on init
        checkForPendingRecording()
    }

    // MARK: - Start Recording
    func startRecording() {
        locationService.startTracking()
        startAutoSave()
    }

    // MARK: - Stop Recording
    func stopRecording() {
        let stats = locationService.stopTracking()
        stopAutoSave()
        crashRecoveryService.clearRecordingState()

        // Store completed activity data
        completedStats = stats
        completedRoute = locationService.route

        // Show summary
        showActivitySummary = true
    }

    // MARK: - Auto-Save
    private func startAutoSave() {
        // Save every 30 seconds
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.saveRecordingState()
        }
    }

    private func stopAutoSave() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = nil
    }

    private func saveRecordingState() {
        guard locationService.isTracking else { return }

        let state = RecordingState(
            activityType: selectedActivityType,
            startTime: Date().addingTimeInterval(-locationService.duration),
            route: locationService.route,
            distance: locationService.distance,
            duration: locationService.duration,
            elevationGain: locationService.elevationGain,
            splits: locationService.splits,
            isPaused: locationService.isPaused,
            pausedDuration: 0  // Calculate if needed
        )

        crashRecoveryService.saveRecordingState(state)
    }

    // MARK: - Crash Recovery
    private func checkForPendingRecording() {
        if crashRecoveryService.hasPendingRecording() {
            showRecoveryAlert = true
        }
    }

    func recoverRecording() {
        guard let state = crashRecoveryService.loadRecordingState() else { return }

        selectedActivityType = state.activityType

        // Restore location service state
        // Note: This is a simplified recovery - in production, you'd need to
        // restore more state in LocationService
        locationService.startTracking()

        showRecoveryAlert = false
    }

    func discardRecovery() {
        crashRecoveryService.clearRecordingState()
        showRecoveryAlert = false
    }

    // MARK: - Cleanup
    deinit {
        stopAutoSave()
    }
}
