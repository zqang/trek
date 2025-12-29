//
//  ContentView.swift
//  Trek
//
//  Root view of the application that manages the main TabView navigation.
//  Provides access to Dashboard, Activity Tracking, and Activities History.
//

import SwiftUI

/// Root view containing the main tab navigation
struct ContentView: View {
    var body: some View {
        TabView {
            // Dashboard Tab - Shows activity summary and stats
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            
            // Tracking Tab - Start and track new activities
            TrackingView()
                .tabItem {
                    Label("Track", systemImage: "location.fill")
                }
            
            // Activities Tab - View history of completed activities
            ActivitiesListView()
                .tabItem {
                    Label("Activities", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
}
