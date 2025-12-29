//
//  ActivitiesListView.swift
//  Trek
//
//  View displaying a list of completed activities.
//  Shows activity history with summary information and allows navigation to details.
//

import SwiftUI

struct ActivitiesListView: View {
    // TODO: Connect to ViewModel for real activity data
    
    // Sample activities data
    @State private var sampleActivities: [SampleActivity] = [
        SampleActivity(
            name: "Morning Run",
            type: .running,
            date: Date().addingTimeInterval(-3600),
            distance: 5.2,
            duration: 1725,
            elevation: 152
        ),
        SampleActivity(
            name: "Evening Cycle",
            type: .cycling,
            date: Date().addingTimeInterval(-86400),
            distance: 22.5,
            duration: 3600,
            elevation: 245
        ),
        SampleActivity(
            name: "Mountain Hike",
            type: .hiking,
            date: Date().addingTimeInterval(-172800),
            distance: 8.7,
            duration: 7200,
            elevation: 580
        ),
        SampleActivity(
            name: "Lunch Walk",
            type: .walking,
            date: Date().addingTimeInterval(-259200),
            distance: 2.1,
            duration: 1200,
            elevation: 25
        )
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                if sampleActivities.isEmpty {
                    emptyStateView
                } else {
                    activitiesList
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Filter/Sort button (placeholder for future functionality)
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
    
    // MARK: - Activities List
    
    private var activitiesList: some View {
        List {
            ForEach(sampleActivities) { activity in
                // TODO: NavigationLink to activity detail view
                ActivityRow(activity: activity)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - Empty State
    
    private var emptyStateView: some View {
        VStack(spacing: Theme.Spacing.lg) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(Theme.Colors.primary.opacity(0.5))
            
            Text("No Activities Yet")
                .font(Theme.Fonts.title2)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("Start tracking your first activity from the Track tab")
                .font(Theme.Fonts.body)
                .foregroundColor(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.background)
    }
}

// MARK: - Activity Row Component

struct ActivityRow: View {
    let activity: SampleActivity
    
    var body: some View {
        VStack(spacing: Theme.Spacing.md) {
            // Header: Name and Date
            HStack {
                Image(systemName: activity.type.iconName)
                    .font(.title2)
                    .foregroundColor(Theme.Colors.primary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.name)
                        .font(Theme.Fonts.headline)
                        .foregroundColor(Theme.Colors.textPrimary)
                    
                    Text(activity.formattedDate)
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            
            // Stats Grid
            HStack(spacing: Theme.Spacing.lg) {
                StatItem(
                    icon: "arrow.left.and.right",
                    value: String(format: "%.1f km", activity.distance),
                    label: "Distance"
                )
                
                StatItem(
                    icon: "clock",
                    value: activity.formattedDuration,
                    label: "Duration"
                )
                
                StatItem(
                    icon: "arrow.up",
                    value: "\(Int(activity.elevation)) m",
                    label: "Elevation"
                )
            }
        }
        .padding()
        .cardStyle()
    }
}

// MARK: - Stat Item Component

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption2)
                Text(value)
                    .font(Theme.Fonts.callout)
            }
            .foregroundColor(Theme.Colors.textPrimary)
            
            Text(label)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Sample Activity Model

/// Temporary sample activity model for UI preview
/// TODO: Replace with actual Activity model from Data layer
struct SampleActivity: Identifiable {
    let id = UUID()
    let name: String
    let type: Constants.ActivityType
    let date: Date
    let distance: Double // in kilometers
    let duration: TimeInterval // in seconds
    let elevation: Double // in meters
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%dh %dm", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%dm %ds", minutes, seconds)
        } else {
            return String(format: "%ds", seconds)
        }
    }
}

#Preview {
    ActivitiesListView()
}
