//
//  ActivitiesListView.swift
//  Trek
//
//  List view displaying all recorded activities with summary information.
//

import SwiftUI

struct ActivitiesListView: View {
    // Sample activities for demonstration
    // TODO: Replace with actual data from SwiftData
    @State private var activities: [ActivitySummary] = [
        ActivitySummary(
            id: UUID(),
            type: .running,
            date: Date().addingTimeInterval(-86400), // Yesterday
            distance: 5.2,
            duration: 1800, // 30 minutes
            calories: 420
        ),
        ActivitySummary(
            id: UUID(),
            type: .cycling,
            date: Date().addingTimeInterval(-172800), // 2 days ago
            distance: 15.8,
            duration: 2700, // 45 minutes
            calories: 580
        ),
        ActivitySummary(
            id: UUID(),
            type: .walking,
            date: Date().addingTimeInterval(-259200), // 3 days ago
            distance: 3.5,
            duration: 2400, // 40 minutes
            calories: 250
        )
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if activities.isEmpty {
                    // Empty state
                    VStack(spacing: Theme.Spacing.md) {
                        Image(systemName: "figure.run.circle")
                            .font(.system(size: 64))
                            .foregroundColor(Theme.Colors.textSecondary)
                        
                        Text("No Activities Yet")
                            .font(Theme.Fonts.title2)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("Start tracking your first activity!")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.Colors.background)
                } else {
                    // Activities list
                    List(activities) { activity in
                        ActivityRow(activity: activity)
                            .listRowInsets(EdgeInsets(
                                top: Theme.Spacing.sm,
                                leading: Theme.Spacing.md,
                                bottom: Theme.Spacing.sm,
                                trailing: Theme.Spacing.md
                            ))
                    }
                    .listStyle(.plain)
                    .background(Theme.Colors.background)
                }
            }
            .navigationTitle("Activities")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Activity Row Component
struct ActivityRow: View {
    let activity: ActivitySummary
    
    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            // Activity Icon
            Image(systemName: activity.type.icon)
                .font(.system(size: 32))
                .foregroundColor(Theme.Colors.primary)
                .frame(width: 50, height: 50)
                .background(Theme.Colors.secondaryBackground)
                .cornerRadius(Theme.CornerRadius.small)
            
            // Activity Details
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(activity.type.rawValue)
                    .font(Theme.Fonts.headline)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Text(formatDate(activity.date))
                    .font(Theme.Fonts.subheadline)
                    .foregroundColor(Theme.Colors.textSecondary)
                
                HStack(spacing: Theme.Spacing.md) {
                    Label(
                        String(format: "%.1f %@", activity.distance, Constants.distanceUnit),
                        systemImage: "map"
                    )
                    .font(Theme.Fonts.caption)
                    
                    Label(
                        formatDuration(activity.duration),
                        systemImage: "clock"
                    )
                    .font(Theme.Fonts.caption)
                    
                    Label(
                        "\(activity.calories) kcal",
                        systemImage: "flame"
                    )
                    .font(Theme.Fonts.caption)
                }
                .foregroundColor(Theme.Colors.textSecondary)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.background)
        .cornerRadius(Theme.CornerRadius.medium)
    }
    
    // Helper function to format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Helper function to format duration
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Activity Summary Model (Temporary)
// This is a temporary model for preview/development
// TODO: Replace with actual Activity model from Data/Models
struct ActivitySummary: Identifiable {
    let id: UUID
    let type: Constants.ActivityType
    let date: Date
    let distance: Double // km
    let duration: TimeInterval // seconds
    let calories: Int
}

#Preview {
    ActivitiesListView()
}
