//
//  TrackingView.swift
//  Trek
//
//  Activity tracking view with map, controls, and activity type selector.
//  Allows users to start, pause, and stop activity tracking.
//

import SwiftUI
import MapKit

struct TrackingView: View {
    // Location service to handle GPS tracking
    @StateObject private var locationService = LocationService()
    
    // Activity state
    @State private var isTracking = false
    @State private var isPaused = false
    @State private var selectedActivityType: Constants.ActivityType = .running
    
    // Activity metrics
    @State private var distance: Double = 0.0 // km
    @State private var duration: TimeInterval = 0.0 // seconds
    @State private var currentSpeed: Double = 0.0 // km/h
    
    // Map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Map View
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    .cornerRadius(Theme.CornerRadius.medium)
                    .padding(Theme.Spacing.md)
                
                // Activity Type Selector
                if !isTracking {
                    ActivityTypeSelector(selectedType: $selectedActivityType)
                        .padding(.horizontal, Theme.Spacing.md)
                }
                
                // Metrics Display
                if isTracking || isPaused {
                    MetricsView(
                        distance: distance,
                        duration: duration,
                        speed: currentSpeed
                    )
                    .padding(Theme.Spacing.md)
                }
                
                Spacer()
                
                // Control Buttons
                VStack(spacing: Theme.Spacing.md) {
                    if !isTracking {
                        // Start Button
                        Button(action: startTracking) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start \(selectedActivityType.rawValue)")
                            }
                            .font(Theme.Fonts.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.Colors.primary)
                            .cornerRadius(Theme.CornerRadius.medium)
                        }
                    } else {
                        HStack(spacing: Theme.Spacing.md) {
                            // Pause/Resume Button
                            Button(action: togglePause) {
                                HStack {
                                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                    Text(isPaused ? "Resume" : "Pause")
                                }
                                .font(Theme.Fonts.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.Colors.secondary)
                                .cornerRadius(Theme.CornerRadius.medium)
                            }
                            
                            // Stop Button
                            Button(action: stopTracking) {
                                HStack {
                                    Image(systemName: "stop.fill")
                                    Text("Stop")
                                }
                                .font(Theme.Fonts.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.Colors.accent)
                                .cornerRadius(Theme.CornerRadius.medium)
                            }
                        }
                    }
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.background)
            .navigationTitle("Record Activity")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            // Request location permissions when view appears
            locationService.requestPermission()
        }
    }
    
    // MARK: - Actions
    
    private func startTracking() {
        isTracking = true
        isPaused = false
        distance = 0.0
        duration = 0.0
        locationService.startTracking()
        // TODO: Start timer for duration tracking
    }
    
    private func togglePause() {
        isPaused.toggle()
        if isPaused {
            locationService.pauseTracking()
        } else {
            locationService.startTracking()
        }
    }
    
    private func stopTracking() {
        isTracking = false
        isPaused = false
        locationService.stopTracking()
        // TODO: Save activity to database
    }
}

// MARK: - Activity Type Selector
struct ActivityTypeSelector: View {
    @Binding var selectedType: Constants.ActivityType
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Activity Type")
                .font(Theme.Fonts.headline)
                .foregroundColor(Theme.Colors.textPrimary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(Constants.ActivityType.allCases, id: \.self) { type in
                        Button(action: {
                            selectedType = type
                        }) {
                            VStack(spacing: Theme.Spacing.xs) {
                                Image(systemName: type.icon)
                                    .font(.system(size: 24))
                                Text(type.rawValue)
                                    .font(Theme.Fonts.caption)
                            }
                            .foregroundColor(selectedType == type ? .white : Theme.Colors.textPrimary)
                            .padding()
                            .background(selectedType == type ? Theme.Colors.primary : Theme.Colors.secondaryBackground)
                            .cornerRadius(Theme.CornerRadius.medium)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Metrics View
struct MetricsView: View {
    let distance: Double
    let duration: TimeInterval
    let speed: Double
    
    var body: some View {
        HStack(spacing: Theme.Spacing.lg) {
            MetricItem(title: "Distance", value: String(format: "%.2f", distance), unit: Constants.distanceUnit)
            MetricItem(title: "Duration", value: formatDuration(duration), unit: "")
            MetricItem(title: "Speed", value: String(format: "%.1f", speed), unit: Constants.speedUnit)
        }
        .padding()
        .background(Theme.Colors.secondaryBackground)
        .cornerRadius(Theme.CornerRadius.medium)
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, secs)
    }
}

struct MetricItem: View {
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(title)
                .font(Theme.Fonts.caption)
                .foregroundColor(Theme.Colors.textSecondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(Theme.Fonts.title2)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                if !unit.isEmpty {
                    Text(unit)
                        .font(Theme.Fonts.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TrackingView()
}
