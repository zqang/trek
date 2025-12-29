//
//  DashboardView.swift
//  Trek
//
//  Dashboard view displaying user's activity summary and weekly statistics.
//

import SwiftUI

struct DashboardView: View {
    // Sample data for demonstration
    @State private var weeklyDistance: Double = 42.5 // km
    @State private var weeklyDuration: TimeInterval = 15600 // seconds (4h 20m)
    @State private var weeklyActivities: Int = 8
    @State private var weeklyCalories: Int = 3250
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    // Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("This Week")
                            .font(Theme.Fonts.largeTitle)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Text("Keep up the great work!")
                            .font(Theme.Fonts.subheadline)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, Theme.Spacing.md)
                    
                    // Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Theme.Spacing.md) {
                        StatCard(
                            icon: "figure.run",
                            title: "Distance",
                            value: String(format: "%.1f", weeklyDistance),
                            unit: Constants.distanceUnit,
                            color: Theme.Colors.primary
                        )
                        
                        StatCard(
                            icon: "clock.fill",
                            title: "Duration",
                            value: formatDuration(weeklyDuration),
                            unit: "",
                            color: Theme.Colors.secondary
                        )
                        
                        StatCard(
                            icon: "list.bullet",
                            title: "Activities",
                            value: "\(weeklyActivities)",
                            unit: "",
                            color: Theme.Colors.accent
                        )
                        
                        StatCard(
                            icon: "flame.fill",
                            title: "Calories",
                            value: "\(weeklyCalories)",
                            unit: "kcal",
                            color: .orange
                        )
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    
                    // Recent Activities Section
                    VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                        Text("Recent Activities")
                            .font(Theme.Fonts.title2)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.horizontal, Theme.Spacing.md)
                        
                        // Placeholder for recent activities
                        Text("No recent activities yet. Start tracking!")
                            .font(Theme.Fonts.body)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .padding(.vertical, Theme.Spacing.lg)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Helper function to format duration
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
            
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(Theme.Fonts.title)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(Theme.Fonts.footnote)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.secondaryBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
}

#Preview {
    DashboardView()
}
