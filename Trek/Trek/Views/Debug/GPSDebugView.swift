//
//  GPSDebugView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import CoreLocation

struct GPSDebugView: View {
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationView {
            List {
                // Permission Status
                Section("Permission Status") {
                    HStack {
                        Text("Authorization")
                        Spacer()
                        Text(authorizationStatusText)
                            .foregroundColor(authorizationStatusColor)
                    }

                    if locationService.authorizationStatus == .notDetermined {
                        Button("Request Permission") {
                            locationService.requestLocationPermission()
                        }
                    }
                }

                // GPS Signal
                Section("GPS Signal") {
                    HStack {
                        Text("Signal Quality")
                        Spacer()
                        GPSSignalIndicator(
                            accuracy: locationService.currentLocation?.horizontalAccuracy,
                            isTracking: locationService.isTracking
                        )
                    }

                    if let location = locationService.currentLocation {
                        DataRow(label: "Accuracy", value: String(format: "±%.1fm", location.horizontalAccuracy))
                        DataRow(label: "Latitude", value: String(format: "%.6f", location.coordinate.latitude))
                        DataRow(label: "Longitude", value: String(format: "%.6f", location.coordinate.longitude))
                        DataRow(label: "Altitude", value: String(format: "%.1fm", location.altitude))
                        DataRow(label: "Speed", value: String(format: "%.2f m/s", location.speed))
                    } else {
                        Text("No location data")
                            .foregroundColor(.secondary)
                    }
                }

                // Tracking Status
                Section("Tracking Status") {
                    Toggle("Is Tracking", isOn: .constant(locationService.isTracking))
                        .disabled(true)

                    Toggle("Is Paused", isOn: .constant(locationService.isPaused))
                        .disabled(true)

                    DataRow(label: "Distance", value: String(format: "%.2f m", locationService.distance))
                    DataRow(label: "Duration", value: locationService.duration.formattedDuration)
                    DataRow(label: "Current Pace", value: String(format: "%.2f s/km", locationService.currentPace))
                    DataRow(label: "Current Speed", value: String(format: "%.2f m/s", locationService.currentSpeed))
                    DataRow(label: "Elevation Gain", value: String(format: "%.1f m", locationService.elevationGain))
                }

                // Route Info
                Section("Route Information") {
                    DataRow(label: "GPS Points", value: "\(locationService.route.count)")
                    DataRow(label: "Splits", value: "\(locationService.splits.count)")

                    if let firstPoint = locationService.route.first {
                        DataRow(label: "Start Time", value: formatTime(firstPoint.timestamp))
                    }

                    if let lastPoint = locationService.route.last {
                        DataRow(label: "Last Update", value: formatTime(lastPoint.timestamp))
                    }
                }

                // Controls
                Section("Controls") {
                    if !locationService.isTracking {
                        Button("Start Tracking") {
                            locationService.startTracking()
                        }
                        .foregroundColor(.green)
                    } else if locationService.isPaused {
                        Button("Resume Tracking") {
                            locationService.resumeTracking()
                        }
                        .foregroundColor(.blue)

                        Button("Stop Tracking") {
                            _ = locationService.stopTracking()
                        }
                        .foregroundColor(.red)
                    } else {
                        Button("Pause Tracking") {
                            locationService.pauseTracking()
                        }
                        .foregroundColor(.orange)

                        Button("Stop Tracking") {
                            _ = locationService.stopTracking()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("GPS Debug")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var authorizationStatusText: String {
        switch locationService.authorizationStatus {
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "Always"
        case .authorizedWhenInUse:
            return "When In Use"
        @unknown default:
            return "Unknown"
        }
    }

    private var authorizationStatusColor: Color {
        switch locationService.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            return .green
        case .denied, .restricted:
            return .red
        default:
            return .orange
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

struct DataRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .font(.system(.body, design: .monospaced))
        }
    }
}

#Preview {
    GPSDebugView()
}
