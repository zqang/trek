//
//  StatsView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct StatsView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Total Stats Header
                totalStatsSection

                // Activity Breakdown
                activityBreakdownSection

                // Average Stats
                averageStatsSection
            }
            .padding()
        }
        .navigationTitle("Your Stats")
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Total Stats Section
    private var totalStatsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Total Stats")
                .font(.headline)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatsCard(
                    icon: "figure.run",
                    value: "\(viewModel.totalActivities)",
                    label: "Activities",
                    color: .blue
                )

                StatsCard(
                    icon: "map",
                    value: viewModel.formattedTotalDistance,
                    label: "Distance",
                    color: .green
                )

                StatsCard(
                    icon: "clock",
                    value: viewModel.formattedTotalDuration,
                    label: "Duration",
                    color: .orange
                )

                StatsCard(
                    icon: "arrow.up.right",
                    value: viewModel.formattedTotalElevation,
                    label: "Elevation",
                    color: .purple
                )
            }
        }
    }

    // MARK: - Activity Breakdown Section
    private var activityBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Activity Breakdown")
                .font(.headline)

            if viewModel.activitiesByType.isEmpty {
                Text("No activities yet")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            } else {
                VStack(spacing: 12) {
                    ForEach(ActivityType.allCases, id: \.self) { type in
                        if let count = viewModel.activitiesByType[type], count > 0 {
                            ActivityTypeRow(
                                type: type,
                                count: count,
                                total: viewModel.totalActivities
                            )
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }

    // MARK: - Average Stats Section
    private var averageStatsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Averages")
                .font(.headline)

            HStack(spacing: 15) {
                AverageStatCard(
                    icon: "map",
                    value: viewModel.formattedAverageDistance,
                    label: "Avg Distance"
                )

                AverageStatCard(
                    icon: "clock",
                    value: viewModel.formattedAverageDuration,
                    label: "Avg Duration"
                )
            }
        }
    }
}

// MARK: - Stats Card
struct StatsCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

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

// MARK: - Activity Type Row
struct ActivityTypeRow: View {
    let type: ActivityType
    let count: Int
    let total: Int

    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }

    var body: some View {
        HStack {
            Image(systemName: type.icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(type.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(.systemGray5))
                            .frame(height: 6)
                            .cornerRadius(3)

                        Rectangle()
                            .fill(Color.accentColor)
                            .frame(width: geometry.size.width * percentage, height: 6)
                            .cornerRadius(3)
                    }
                }
                .frame(height: 6)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(count)")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("\(Int(percentage * 100))%")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Average Stat Card
struct AverageStatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

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

#Preview {
    NavigationView {
        StatsView(viewModel: {
            let vm = ProfileViewModel(userId: "test")
            vm.totalActivities = 42
            vm.totalDistance = 210000 // 210 km
            vm.totalDuration = 75600 // 21 hours
            vm.totalElevationGain = 2100 // 2100 m
            vm.activitiesByType = [
                .run: 25,
                .ride: 10,
                .walk: 5,
                .hike: 2
            ]
            return vm
        }())
    }
}
