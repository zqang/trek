//
//  TrackingView.swift
//  Trek
//
//  View for tracking new activities with real-time GPS and map visualization.
//  Allows users to start, pause, and stop activity tracking sessions.
//

import SwiftUI
import MapKit

struct TrackingView: View {
    // TODO: Connect to LocationService and ViewModel
    
    // State for tracking control
    @State private var isTracking = false
    @State private var isPaused = false
    @State private var selectedActivityType: Constants.ActivityType = .running
    
    // Sample tracking stats (to be replaced with real data)
    @State private var distance: Double = 0.0
    @State private var duration: TimeInterval = 0
    @State private var currentSpeed: Double = 0.0
    
    // Map region state
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), // San Francisco
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                // Map View
                mapView
                
                // Overlay with stats and controls
                VStack(spacing: 0) {
                    Spacer()
                    
                    if isTracking {
                        // Stats overlay when tracking
                        statsOverlay
                    }
                    
                    // Control panel
                    controlPanel
                }
            }
            .navigationTitle("Track Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // MARK: - Map View
    
    private var mapView: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow))
            .edgesIgnoringSafeArea(.top)
            .overlay(
                // Overlay instructions when not tracking
                Group {
                    if !isTracking {
                        VStack {
                            Spacer()
                            Text("Select activity type and tap Start to begin tracking")
                                .font(Theme.Fonts.callout)
                                .foregroundColor(Theme.Colors.textSecondary)
                                .padding()
                                .background(Theme.Colors.cardBackground.opacity(0.9))
                                .cornerRadius(Theme.CornerRadius.sm)
                                .padding()
                            Spacer()
                                .frame(height: 300) // Space for control panel
                        }
                    }
                }
            )
    }
    
    // MARK: - Stats Overlay
    
    private var statsOverlay: some View {
        HStack(spacing: Theme.Spacing.lg) {
            // Distance
            StatColumn(
                title: "Distance",
                value: String(format: "%.2f", distance),
                unit: "km"
            )
            
            Divider()
                .frame(height: 60)
            
            // Duration
            StatColumn(
                title: "Duration",
                value: formatDuration(duration),
                unit: ""
            )
            
            Divider()
                .frame(height: 60)
            
            // Speed
            StatColumn(
                title: "Speed",
                value: String(format: "%.1f", currentSpeed),
                unit: "km/h"
            )
        }
        .padding()
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Theme.CornerRadius.md)
        .padding()
        .shadow(
            color: Theme.Shadow.medium.color,
            radius: Theme.Shadow.medium.radius,
            x: Theme.Shadow.medium.x,
            y: Theme.Shadow.medium.y
        )
    }
    
    // MARK: - Control Panel
    
    private var controlPanel: some View {
        VStack(spacing: Theme.Spacing.md) {
            if !isTracking {
                // Activity Type Selector
                activityTypeSelector
            }
            
            // Control Buttons
            HStack(spacing: Theme.Spacing.md) {
                if isTracking {
                    // Pause/Resume Button
                    Button(action: togglePause) {
                        HStack {
                            Image(systemName: isPaused ? "play.fill" : "pause.fill")
                            Text(isPaused ? "Resume" : "Pause")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.Colors.secondary)
                        .foregroundColor(.white)
                        .cornerRadius(Theme.CornerRadius.md)
                    }
                    
                    // Stop Button
                    Button(action: stopTracking) {
                        HStack {
                            Image(systemName: "stop.fill")
                            Text("Stop")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.Colors.error)
                        .foregroundColor(.white)
                        .cornerRadius(Theme.CornerRadius.md)
                    }
                } else {
                    // Start Button
                    Button(action: startTracking) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Start \(selectedActivityType.rawValue)")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(Theme.CornerRadius.md)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Theme.Colors.cardBackground)
        .shadow(
            color: Theme.Shadow.heavy.color,
            radius: Theme.Shadow.heavy.radius,
            x: Theme.Shadow.heavy.x,
            y: Theme.Shadow.heavy.y
        )
    }
    
    // MARK: - Activity Type Selector
    
    private var activityTypeSelector: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Activity Type")
                .font(Theme.Fonts.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(Constants.ActivityType.allCases) { type in
                        Button(action: { selectedActivityType = type }) {
                            VStack(spacing: Theme.Spacing.xs) {
                                Image(systemName: type.iconName)
                                    .font(.title2)
                                Text(type.rawValue)
                                    .font(Theme.Fonts.caption)
                            }
                            .frame(width: 80, height: 70)
                            .background(selectedActivityType == type ? Theme.Colors.primary : Theme.Colors.cardBackground)
                            .foregroundColor(selectedActivityType == type ? .white : Theme.Colors.textPrimary)
                            .cornerRadius(Theme.CornerRadius.sm)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Actions
    
    private func startTracking() {
        isTracking = true
        isPaused = false
        // TODO: Call LocationService.startTracking()
        // TODO: Start timer for duration
        print("Started tracking \(selectedActivityType.rawValue)")
    }
    
    private func togglePause() {
        isPaused.toggle()
        // TODO: Call LocationService.pauseTracking() or resumeTracking()
        print(isPaused ? "Paused tracking" : "Resumed tracking")
    }
    
    private func stopTracking() {
        isTracking = false
        isPaused = false
        // TODO: Call LocationService.stopTracking()
        // TODO: Save activity to database
        // TODO: Navigate to activity summary
        print("Stopped tracking. Distance: \(distance) km, Duration: \(duration) seconds")
        
        // Reset stats
        distance = 0.0
        duration = 0
        currentSpeed = 0.0
    }
    
    // MARK: - Helper Methods
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - Stat Column Component

struct StatColumn: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            Text(value)
                .font(Theme.Fonts.stat)
                .foregroundColor(Theme.Colors.textPrimary)
            if !unit.isEmpty {
                Text(unit)
                    .font(Theme.Fonts.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TrackingView()
}
