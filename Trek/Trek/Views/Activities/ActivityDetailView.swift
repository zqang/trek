//
//  ActivityDetailView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ActivityDetailView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ActivityDetailViewModel
    @State private var showingDeleteConfirmation = false

    init(activity: Activity) {
        _viewModel = StateObject(wrappedValue: ActivityDetailViewModel(activity: activity))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Map
                    if !viewModel.activity.route.isEmpty {
                        RouteMapView(route: viewModel.activity.route)
                            .frame(height: 300)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }

                    // Activity Header
                    if viewModel.isEditing {
                        editingHeader
                    } else {
                        activityHeader
                    }

                    // Main Stats Grid
                    mainStatsGrid

                    // Splits Section
                    if !viewModel.activity.splits.isEmpty {
                        splitsSection
                    }

                    // Additional Details
                    additionalDetailsSection

                    // Action Buttons
                    if !viewModel.isEditing {
                        actionButtons
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle(viewModel.isEditing ? "Edit Activity" : "Activity Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.isEditing {
                        Button("Cancel") {
                            viewModel.cancelEditing()
                        }
                    } else {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.isEditing {
                        Button("Save") {
                            Task {
                                let success = await viewModel.saveChanges()
                                if success {
                                    // Editing mode will be turned off by viewModel
                                }
                            }
                        }
                        .disabled(viewModel.isSaving || !viewModel.hasChanges)
                    } else {
                        Menu {
                            Button(action: {
                                viewModel.startEditing()
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }

                            Button(action: {
                                viewModel.shareGPX()
                            }) {
                                Label("Share GPX", systemImage: "square.and.arrow.up")
                            }

                            Button(role: .destructive, action: {
                                showingDeleteConfirmation = true
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert("Delete Activity?", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        let success = await viewModel.deleteActivity()
                        if success {
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete \"\(viewModel.activity.name)\"? This action cannot be undone.")
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }

    // MARK: - Activity Header (View Mode)
    private var activityHeader: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: viewModel.activity.type.icon)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)

                VStack(alignment: .leading, spacing: 5) {
                    Text(viewModel.activity.name)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(viewModel.formattedDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if !viewModel.activity.isPrivate {
                    VStack {
                        Image(systemName: "globe")
                            .font(.title3)
                            .foregroundColor(.secondary)

                        Text("Public")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Activity Header (Edit Mode)
    private var editingHeader: some View {
        VStack(spacing: 20) {
            // Activity Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Activity Name")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                TextField("Enter name", text: $viewModel.editedName)
                    .textFieldStyle(.roundedBorder)
            }

            // Activity Type
            VStack(alignment: .leading, spacing: 8) {
                Text("Activity Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 12) {
                    ForEach(ActivityType.allCases, id: \.self) { type in
                        ActivityTypeButton(
                            type: type,
                            isSelected: viewModel.editedType == type,
                            action: { viewModel.editedType = type }
                        )
                    }
                }
            }

            // Privacy Toggle
            Toggle(isOn: $viewModel.editedIsPrivate) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Private Activity")
                        .font(.subheadline)
                    Text("Only you can see this activity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    // MARK: - Main Stats Grid
    private var mainStatsGrid: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Stats")
                .font(.headline)
                .padding(.horizontal)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                DetailStatCard(
                    icon: "figure.run",
                    label: "Distance",
                    value: viewModel.formattedDistance
                )

                DetailStatCard(
                    icon: "clock",
                    label: "Duration",
                    value: viewModel.formattedDuration
                )

                DetailStatCard(
                    icon: viewModel.activity.type == .ride ? "speedometer" : "timer",
                    label: viewModel.activity.type == .ride ? "Avg Speed" : "Avg Pace",
                    value: viewModel.activity.type == .ride ? viewModel.formattedSpeed : viewModel.formattedPace
                )

                DetailStatCard(
                    icon: "arrow.up.right",
                    label: "Elevation Gain",
                    value: viewModel.formattedElevation
                )
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Splits Section
    private var splitsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Splits")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 0) {
                ForEach(viewModel.activity.splits) { split in
                    SplitRowView(split: split, unit: .metric)
                    if split.index < viewModel.activity.splits.count {
                        Divider()
                    }
                }
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    // MARK: - Additional Details
    private var additionalDetailsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Details")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 12) {
                DetailRow(
                    icon: "calendar",
                    label: "Start Time",
                    value: viewModel.activity.startTime.formatted(date: .abbreviated, time: .shortened)
                )

                DetailRow(
                    icon: "flag.checkered",
                    label: "End Time",
                    value: viewModel.activity.endTime.formatted(date: .abbreviated, time: .shortened)
                )

                DetailRow(
                    icon: "mappin.and.ellipse",
                    label: "GPS Points",
                    value: "\(viewModel.activity.route.count)"
                )

                DetailRow(
                    icon: "chart.line.uptrend.xyaxis",
                    label: "Splits",
                    value: "\(viewModel.activity.splits.count)"
                )

                if viewModel.activity.isPrivate {
                    DetailRow(
                        icon: "lock.fill",
                        label: "Visibility",
                        value: "Private"
                    )
                } else {
                    DetailRow(
                        icon: "globe",
                        label: "Visibility",
                        value: "Public"
                    )
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.shareGPX()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Export as GPX")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
            }

            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Activity")
                }
                .font(.headline)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}

// MARK: - Detail Stat Card
struct DetailStatCard: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 12) {
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

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.accentColor)
                .frame(width: 25)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ActivityDetailView(
        activity: Activity(
            id: "1",
            userId: "user1",
            name: "Morning Run",
            type: .run,
            startTime: Date().addingTimeInterval(-3600),
            endTime: Date(),
            distance: 5000,
            duration: 1800,
            elevationGain: 45,
            route: [
                LocationPoint(latitude: 37.33182, longitude: -122.03118, altitude: 20, timestamp: Date(), speed: 2.5, horizontalAccuracy: 10),
                LocationPoint(latitude: 37.33282, longitude: -122.03218, altitude: 22, timestamp: Date(), speed: 2.5, horizontalAccuracy: 10)
            ],
            splits: [
                Split(index: 1, distance: 1000, duration: 360, pace: 360),
                Split(index: 2, distance: 1000, duration: 355, pace: 355)
            ],
            isPrivate: false,
            createdAt: Date()
        )
    )
}
