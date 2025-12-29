//
//  SettingsView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import UserNotifications

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingResetConfirmation = false
    @State private var showingClearCacheConfirmation = false

    var body: some View {
        NavigationView {
            Form {
                // Units Section
                Section(header: Text("Units")) {
                    Picker("Distance & Speed", selection: $viewModel.unitSystem) {
                        Text("Metric (km, km/h)").tag(UnitSystem.metric)
                        Text("Imperial (mi, mph)").tag(UnitSystem.imperial)
                    }
                }

                // Activity Defaults Section
                Section(header: Text("Activity Defaults")) {
                    Toggle("Private by Default", isOn: $viewModel.defaultActivityPrivacy)

                    Picker("Auto-Save Interval", selection: $viewModel.autoSaveInterval) {
                        ForEach(viewModel.autoSaveIntervalOptions, id: \.self) { interval in
                            Text(viewModel.autoSaveIntervalText(interval)).tag(interval)
                        }
                    }
                }

                // Display Section
                Section(header: Text("Display")) {
                    Toggle("Show GPS Accuracy", isOn: $viewModel.showGPSAccuracy)
                }

                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $viewModel.enableNotifications)
                }
                .onChange(of: viewModel.enableNotifications) { newValue in
                    if newValue {
                        requestNotificationPermission()
                    }
                }

                // Data Management Section
                Section(header: Text("Data Management")) {
                    Button(action: {
                        showingClearCacheConfirmation = true
                    }) {
                        HStack {
                            Text("Clear Cache")
                            Spacer()
                            Image(systemName: "trash")
                        }
                    }
                    .foregroundColor(.blue)
                }

                // Reset Section
                Section {
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        HStack {
                            Text("Reset to Defaults")
                            Spacer()
                            Image(systemName: "arrow.counterclockwise")
                        }
                    }
                    .foregroundColor(.orange)
                }

                // About Section
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(viewModel.versionString)
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://github.com/anthropics/claude-code")!) {
                        HStack {
                            Text("GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }

                    Link(destination: URL(string: "https://docs.claude.com/en/docs/claude-code")!) {
                        HStack {
                            Text("Documentation")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Reset Settings?", isPresented: $showingResetConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    viewModel.resetToDefaults()
                }
            } message: {
                Text("This will reset all settings to their default values.")
            }
            .alert("Clear Cache?", isPresented: $showingClearCacheConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Clear", role: .destructive) {
                    viewModel.clearCache()
                }
            } message: {
                Text("This will clear cached data. Your activities and settings will be preserved.")
            }
        }
    }

    // MARK: - Request Notification Permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
                DispatchQueue.main.async {
                    viewModel.enableNotifications = false
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
