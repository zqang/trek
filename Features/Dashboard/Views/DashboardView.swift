//
//  DashboardView.swift
//  Trek
//
//  Dashboard view showing activity summary and weekly statistics.
//  Provides an overview of recent activities and key performance metrics.
//

import SwiftUI

struct DashboardView: View {
    // TODO: Connect to ViewModel for real data
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Theme.Spacing.lg) {
                    // Welcome Header
                    headerSection
                    
                    // Weekly Stats Summary
                    weeklyStatsSection
                    
                    // Recent Activity
                    recentActivitySection
                    
                    // Goals Progress (placeholder for future)
                    goalsSection
                }
                .padding()
            }
            .background(Theme.Colors.background)
            .navigationTitle("Dashboard")
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Welcome back!")
                .font(Theme.Fonts.title2)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("Here's your weekly progress")
                .font(Theme.Fonts.callout)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Weekly Stats Section
    
    private var weeklyStatsSection: some View {
        VStack(spacing: Theme.Spacing.md) {
            Text("This Week")
                .font(Theme.Fonts.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: Theme.Spacing.md) {
                // Distance Stat
                StatCard(
                    title: "Distance",
                    value: "42.5",
                    unit: "km",
                    icon: "figure.run",
                    color: Theme.Colors.primary
                )
                
                // Duration Stat
                StatCard(
                    title: "Duration",
                    value: "5.2",
                    unit: "hrs",
                    icon: "clock.fill",
                    color: Theme.Colors.secondary
                )
            }
            
            HStack(spacing: Theme.Spacing.md) {
                // Activities Count
                StatCard(
                    title: "Activities",
                    value: "7",
                    unit: "total",
                    icon: "list.bullet",
                    color: Theme.Colors.accent
                )
                
                // Calories Stat
                StatCard(
                    title: "Calories",
                    value: "3,245",
                    unit: "kcal",
                    icon: "flame.fill",
                    color: .red
                )
            }
        }
    }
    
    // MARK: - Recent Activity Section
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Recent Activity")
                .font(Theme.Fonts.headline)
            
            // Sample recent activity card
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Image(systemName: "figure.run")
                        .foregroundColor(Theme.Colors.primary)
                    Text("Morning Run")
                        .font(Theme.Fonts.headline)
                    Spacer()
                    Text("Today")
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                HStack {
                    Label("5.2 km", systemImage: "arrow.left.and.right")
                    Spacer()
                    Label("28:45", systemImage: "clock")
                    Spacer()
                    Label("152 m", systemImage: "arrow.up")
                }
                .font(Theme.Fonts.callout)
                .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding()
            .cardStyle()
        }
    }
    
    // MARK: - Goals Section
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Weekly Goals")
                .font(Theme.Fonts.headline)
            
            // Sample goal progress
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Text("Distance Goal")
                        .font(Theme.Fonts.callout)
                    Spacer()
                    Text("42.5 / 50 km")
                        .font(Theme.Fonts.callout)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
                
                ProgressView(value: 0.85)
                    .tint(Theme.Colors.secondary)
            }
            .padding()
            .cardStyle()
        }
    }
}

// MARK: - Stat Card Component

/// Reusable stat card component for displaying metrics
struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(Theme.Fonts.stat)
                .foregroundColor(Theme.Colors.textPrimary)
            
            Text("\(title) (\(unit))")
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .cardStyle()
    }
}

#Preview {
    DashboardView()
}
