//
//  ActivityRowView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ActivityRowView: View {
    let activity: Activity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Type icon + Name + Date
            HStack {
                Image(systemName: activity.type.icon)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .frame(width: 30)

                VStack(alignment: .leading, spacing: 2) {
                    Text(activity.name)
                        .font(.headline)
                        .lineLimit(1)

                    Text(activity.startTime.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if !activity.isPrivate {
                    Image(systemName: "globe")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            // Stats Grid
            HStack(spacing: 20) {
                StatColumn(
                    icon: "figure.run",
                    value: Formatters.formatDistance(activity.distance, unit: .metric),
                    label: "Distance"
                )

                StatColumn(
                    icon: "clock",
                    value: activity.duration.formattedDuration,
                    label: "Duration"
                )

                StatColumn(
                    icon: activity.type == .ride ? "speedometer" : "timer",
                    value: activity.type == .ride ?
                        Formatters.formatSpeed(activity.averageSpeed / 3.6, unit: .metric) :
                        Formatters.formatPace(activity.averagePace, unit: .metric),
                    label: activity.type == .ride ? "Avg Speed" : "Avg Pace"
                )

                StatColumn(
                    icon: "arrow.up.right",
                    value: Formatters.formatElevation(activity.elevationGain, unit: .metric),
                    label: "Elevation"
                )
            }

            // Mini map preview (if route exists)
            if !activity.route.isEmpty {
                RouteMapView(route: activity.route)
                    .frame(height: 120)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }

    // Computed properties for stats
    private var averageSpeed: Double {
        guard activity.duration > 0 else { return 0 }
        return activity.distance / activity.duration
    }

    private var averagePace: Double {
        guard activity.distance > 0 else { return 0 }
        return activity.duration / (activity.distance / 1000)
    }
}

// MARK: - Stat Column
struct StatColumn: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    ScrollView {
        VStack(spacing: 15) {
            ActivityRowView(
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
                        LocationPoint(latitude: 37.33182, longitude: -122.03118, altitude: 20, timestamp: Date(), speed: 2.5, horizontalAccuracy: 10)
                    ],
                    splits: [],
                    isPrivate: false,
                    createdAt: Date()
                )
            )

            ActivityRowView(
                activity: Activity(
                    id: "2",
                    userId: "user1",
                    name: "Evening Ride",
                    type: .ride,
                    startTime: Date().addingTimeInterval(-7200),
                    endTime: Date().addingTimeInterval(-3600),
                    distance: 25000,
                    duration: 3600,
                    elevationGain: 120,
                    route: [],
                    splits: [],
                    isPrivate: true,
                    createdAt: Date()
                )
            )
        }
        .padding()
    }
}
