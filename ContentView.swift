//
//  ContentView.swift
//  Trek
//
//  Root view of the application that displays the main TabView
//  with navigation between Dashboard, Tracking, and Activities screens.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            TrackingView()
                .tabItem {
                    Label("Record", systemImage: "figure.run")
                }
            
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
