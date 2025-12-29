//
//  LocationPermissionView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import CoreLocation

struct LocationPermissionView: View {
    @ObservedObject var locationService: LocationService
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Icon
            Image(systemName: "location.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)

            // Title
            Text("Location Access Required")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // Description
            Text("Trek needs access to your location to track your activities accurately. Your location data is only used during activity recording and is never shared without your permission.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Features
            VStack(alignment: .leading, spacing: 20) {
                PermissionFeature(
                    icon: "map.fill",
                    title: "Accurate Routes",
                    description: "Record your exact path with GPS"
                )

                PermissionFeature(
                    icon: "speedometer",
                    title: "Real-Time Stats",
                    description: "Track your pace and distance live"
                )

                PermissionFeature(
                    icon: "lock.fill",
                    title: "Privacy First",
                    description: "Data is private and secure"
                )
            }
            .padding(.horizontal, 40)

            Spacer()

            // Status and Action Button
            VStack(spacing: 15) {
                switch locationService.authorizationStatus {
                case .notDetermined:
                    Button(action: {
                        locationService.requestLocationPermission()
                    }) {
                        Text("Allow Location Access")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }

                case .denied, .restricted:
                    VStack(spacing: 10) {
                        Text("Location access is currently disabled")
                            .font(.subheadline)
                            .foregroundColor(.red)

                        Button(action: {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Open Settings")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                        }
                    }

                case .authorizedWhenInUse, .authorizedAlways:
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Location access enabled")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }

                        Button(action: { dismiss() }) {
                            Text("Continue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(12)
                        }
                    }

                @unknown default:
                    EmptyView()
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

struct PermissionFeature: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    LocationPermissionView(locationService: LocationService())
}
