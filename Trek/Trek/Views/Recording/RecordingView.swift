//
//  RecordingView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import CoreLocation

struct RecordingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = RecordingViewModel()
    @State private var showingLocationPermission = false
    @State private var showingActivityTypeSelector = false

    // Access locationService through viewModel for consistency
    private var locationService: LocationService {
        viewModel.locationService
    }

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.locationService.authorizationStatus == .authorizedWhenInUse ||
                   viewModel.locationService.authorizationStatus == .authorizedAlways {
                    // Recording interface
                    recordingInterface
                } else {
                    // Permission required state
                    permissionRequiredView
                }
            }
            .navigationTitle("Record")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: { showingActivityTypeSelector = true }) {
                            Label("Activity Type", systemImage: "figure.run")
                        }

                        #if DEBUG
                        Button(action: {}) {
                            Label("GPS Debug", systemImage: "antenna.radiowaves.left.and.right")
                        }
                        #endif
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showingLocationPermission) {
                LocationPermissionView(locationService: locationService)
            }
            .sheet(isPresented: $viewModel.showActivitySummary) {
                if let stats = viewModel.completedStats {
                    ActivitySummaryView(
                        stats: stats,
                        route: viewModel.completedRoute,
                        activityType: viewModel.selectedActivityType
                    )
                    .environmentObject(authViewModel)
                }
            }
            .alert("Recover Activity?", isPresented: $viewModel.showRecoveryAlert) {
                Button("Resume") {
                    viewModel.recoverRecording()
                }
                Button("Discard", role: .destructive) {
                    viewModel.discardRecovery()
                }
            } message: {
                Text("You have an incomplete activity. Would you like to resume or discard it?")
            }
            .onReceive(viewModel.locationService.objectWillChange) { _ in
                // Force view update when locationService changes
            }
        }
    }

    // MARK: - Permission Required View
    private var permissionRequiredView: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "location.slash")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("Location Required")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Trek needs location access to track your activities. Tap below to enable.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button(action: {
                showingLocationPermission = true
            }) {
                Text("Enable Location")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
    }

    // MARK: - Recording Interface
    private var recordingInterface: some View {
        VStack(spacing: 30) {
            // GPS Signal Indicator
            HStack {
                Spacer()
                GPSSignalIndicator(
                    accuracy: locationService.currentLocation?.horizontalAccuracy,
                    isTracking: locationService.isTracking
                )
            }
            .padding()

            // Activity Type Selector
            if !locationService.isTracking {
                activityTypeSelector
            }

            Spacer()

            // Live Stats (when tracking)
            if locationService.isTracking {
                liveStatsView
            }

            Spacer()

            // Main Control Button
            mainControlButton

            // Secondary Controls (when tracking)
            if locationService.isTracking {
                secondaryControls
            }

            Spacer()
        }
    }

    // MARK: - Activity Type Selector
    private var activityTypeSelector: some View {
        VStack(spacing: 15) {
            Text("Select Activity Type")
                .font(.headline)

            HStack(spacing: 15) {
                ForEach(ActivityType.allCases, id: \.self) { type in
                    ActivityTypeButton(
                        type: type,
                        isSelected: viewModel.selectedActivityType == type,
                        action: { viewModel.selectedActivityType = type }
                    )
                }
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Live Stats View
    private var liveStatsView: some View {
        VStack(spacing: 20) {
            // Duration
            Text(locationService.duration.formattedDuration)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .monospacedDigit()

            // Distance and Pace/Speed
            HStack(spacing: 40) {
                StatItem(
                    label: "Distance",
                    value: String(format: "%.2f", locationService.distance / 1000),
                    unit: "km"
                )

                StatItem(
                    label: viewModel.selectedActivityType == .ride ? "Speed" : "Pace",
                    value: viewModel.selectedActivityType == .ride ?
                        String(format: "%.1f", locationService.currentSpeed * 3.6) :
                        Formatters.formatPace(locationService.currentPace, unit: .metric),
                    unit: viewModel.selectedActivityType == .ride ? "km/h" : ""
                )

                StatItem(
                    label: "Elevation",
                    value: String(format: "%.0f", locationService.elevationGain),
                    unit: "m"
                )
            }
        }
    }

    // MARK: - Main Control Button
    private var mainControlButton: some View {
        Button(action: mainControlAction) {
            VStack(spacing: 10) {
                Image(systemName: mainControlIcon)
                    .font(.system(size: 50))

                Text(mainControlText)
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(width: 180, height: 180)
            .background(mainControlColor)
            .clipShape(Circle())
        }
    }

    // MARK: - Secondary Controls
    private var secondaryControls: some View {
        HStack(spacing: 40) {
            Button(action: {
                if locationService.isPaused {
                    locationService.resumeTracking()
                } else {
                    locationService.pauseTracking()
                }
            }) {
                VStack {
                    Image(systemName: locationService.isPaused ? "play.fill" : "pause.fill")
                        .font(.title2)

                    Text(locationService.isPaused ? "Resume" : "Pause")
                        .font(.caption)
                }
                .foregroundColor(.orange)
            }

            Button(action: {
                _ = locationService.stopTracking()
            }) {
                VStack {
                    Image(systemName: "stop.fill")
                        .font(.title2)

                    Text("Finish")
                        .font(.caption)
                }
                .foregroundColor(.red)
            }
        }
    }

    // MARK: - Control Logic
    private var mainControlIcon: String {
        if !locationService.isTracking {
            return "play.fill"
        } else if locationService.isPaused {
            return "play.fill"
        } else {
            return "stop.fill"
        }
    }

    private var mainControlText: String {
        if !locationService.isTracking {
            return "Start"
        } else if locationService.isPaused {
            return "Resume"
        } else {
            return "Finish"
        }
    }

    private var mainControlColor: Color {
        if !locationService.isTracking {
            return .green
        } else if locationService.isPaused {
            return .blue
        } else {
            return .red
        }
    }

    private func mainControlAction() {
        if !locationService.isTracking {
            viewModel.startRecording()
        } else if locationService.isPaused {
            locationService.resumeTracking()
        } else {
            viewModel.stopRecording()
        }
    }
}

// MARK: - Activity Type Button
struct ActivityTypeButton: View {
    let type: ActivityType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.title2)

                Text(type.displayName)
                    .font(.caption)
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 70, height: 70)
            .background(isSelected ? Color.accentColor : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .monospacedDigit()

                if !unit.isEmpty {
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

#Preview {
    RecordingView()
        .environmentObject(AuthViewModel())
}
