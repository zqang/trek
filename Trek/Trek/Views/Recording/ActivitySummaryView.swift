//
//  ActivitySummaryView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ActivitySummaryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel

    let stats: ActivityStats
    let route: [LocationPoint]
    let activityType: ActivityType

    @State private var activityName: String = ""
    @State private var selectedType: ActivityType
    @State private var isSaving = false
    @State private var showingError = false
    @State private var errorMessage: String?
    @State private var savedActivityId: String?

    private let activityService = ActivityService()

    init(stats: ActivityStats, route: [LocationPoint], activityType: ActivityType) {
        self.stats = stats
        self.route = route
        self.activityType = activityType
        _selectedType = State(initialValue: activityType)

        // Generate default name
        let timeOfDay = Date().timeOfDay
        _activityName = State(initialValue: "\(timeOfDay) \(activityType.displayName)")
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Success Header
                    VStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.green)

                        Text("Activity Completed!")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .padding(.top, 20)

                    // Map
                    if !route.isEmpty {
                        RouteMapView(route: route)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }

                    // Stats Grid
                    statsGrid

                    // Splits
                    if !stats.splits.isEmpty {
                        splitsSection
                    }

                    // Activity Details
                    activityDetailsSection

                    // Save Button
                    saveButton

                    // Discard Button
                    if savedActivityId == nil {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Discard Activity")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Activity Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if savedActivityId != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
            }
            .alert("Error Saving Activity", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
        }
    }

    // MARK: - Stats Grid
    private var statsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            StatCard(
                icon: "figure.run",
                value: Formatters.formatDistance(stats.distance, unit: .metric),
                label: "Distance"
            )

            StatCard(
                icon: "clock",
                value: stats.duration.formattedDuration,
                label: "Duration"
            )

            StatCard(
                icon: selectedType == .ride ? "speedometer" : "timer",
                value: selectedType == .ride ?
                    Formatters.formatSpeed(stats.speed / 3.6, unit: .metric) :
                    Formatters.formatPace(stats.pace, unit: .metric),
                label: selectedType == .ride ? "Avg Speed" : "Avg Pace"
            )

            StatCard(
                icon: "arrow.up.right",
                value: Formatters.formatElevation(stats.elevationGain, unit: .metric),
                label: "Elevation"
            )

            StatCard(
                icon: "figure.walk",
                value: "\(route.count)",
                label: "GPS Points"
            )

            StatCard(
                icon: "ruler",
                value: "\(stats.splits.count)",
                label: "Splits"
            )
        }
        .padding(.horizontal)
    }

    // MARK: - Splits Section
    private var splitsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Splits")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(stats.splits) { split in
                    SplitRowView(split: split, unit: .metric)
                    if split.index < stats.splits.count {
                        Divider()
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    // MARK: - Activity Details Section
    private var activityDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Activity Details")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 15) {
                // Activity Name
                VStack(alignment: .leading, spacing: 5) {
                    Text("Activity Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    TextField("Enter name", text: $activityName)
                        .textFieldStyle(.roundedBorder)
                }

                // Activity Type
                VStack(alignment: .leading, spacing: 5) {
                    Text("Activity Type")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(spacing: 10) {
                        ForEach(ActivityType.allCases, id: \.self) { type in
                            ActivityTypeButton(
                                type: type,
                                isSelected: selectedType == type,
                                action: { selectedType = type }
                            )
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: saveActivity) {
            if isSaving {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if savedActivityId != nil {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Activity Saved")
                }
                .font(.headline)
                .foregroundColor(.white)
            } else {
                Text("Save Activity")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(savedActivityId != nil ? Color.green : Color.accentColor)
        .cornerRadius(12)
        .padding(.horizontal)
        .disabled(isSaving || savedActivityId != nil)
    }

    // MARK: - Save Activity
    private func saveActivity() {
        guard let userId = authViewModel.currentUser?.id else {
            errorMessage = "User not logged in"
            showingError = true
            return
        }

        isSaving = true

        Task {
            do {
                let activity = Activity(
                    id: nil,
                    userId: userId,
                    name: activityName.isEmpty ? "\(Date().timeOfDay) \(selectedType.displayName)" : activityName,
                    type: selectedType,
                    startTime: Date().addingTimeInterval(-stats.duration),
                    endTime: Date(),
                    distance: stats.distance,
                    duration: stats.duration,
                    elevationGain: stats.elevationGain,
                    route: route,
                    splits: stats.splits,
                    isPrivate: true,
                    createdAt: Date()
                )

                let activityId = try await activityService.saveActivity(activity)
                savedActivityId = activityId
                isSaving = false
            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                isSaving = false
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .monospacedDigit()

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Split Row View
struct SplitRowView: View {
    let split: Split
    let unit: UnitSystem

    var body: some View {
        HStack {
            Text("Split \(split.index)")
                .font(.subheadline)
                .fontWeight(.medium)

            Spacer()

            Text(Formatters.formatDistance(split.distance, unit: unit))
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text(split.formattedPace)
                .font(.subheadline)
                .fontWeight(.semibold)
                .monospacedDigit()
        }
        .padding()
    }
}

#Preview {
    ActivitySummaryView(
        stats: ActivityStats(
            distance: 5000,
            duration: 1800,
            pace: 360,
            speed: 2.77,
            elevationGain: 45,
            splits: [
                Split(index: 1, distance: 1000, duration: 360, pace: 360),
                Split(index: 2, distance: 1000, duration: 355, pace: 355)
            ]
        ),
        route: [
            LocationPoint(latitude: 37.33182, longitude: -122.03118, altitude: 20, timestamp: Date(), speed: 2.5, horizontalAccuracy: 10)
        ],
        activityType: .run
    )
    .environmentObject(AuthViewModel())
}
