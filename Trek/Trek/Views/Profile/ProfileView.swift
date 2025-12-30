//
//  ProfileView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import os.log

private let logger = Logger(subsystem: "com.trek", category: "ProfileView")

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: ProfileViewModel
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @State private var showingDataExport = false
    @State private var showingDeleteConfirmation = false
    @State private var showingSignOutConfirmation = false

    init(userId: String) {
        _viewModel = StateObject(wrappedValue: ProfileViewModel(userId: userId))
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Profile Header
                    profileHeader

                    // Quick Stats
                    quickStats

                    // Menu Options
                    menuOptions

                    // Danger Zone
                    dangerZone
                }
                .padding()
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.fetchUserProfile()
            }
            .refreshable {
                await viewModel.fetchUserProfile()
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingDataExport) {
                DataExportView(userId: viewModel.userId)
            }
            .alert("Sign Out?", isPresented: $showingSignOutConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Sign Out", role: .destructive) {
                    do {
                        try viewModel.signOut()
                    } catch {
                        logger.error("Sign out error: \(error.localizedDescription)")
                    }
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .alert("Delete Account?", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        let success = await viewModel.deleteAccount()
                        if success {
                            // Account deleted, user will be signed out automatically
                        }
                    }
                }
            } message: {
                Text("This will permanently delete your account and all your data. This action cannot be undone.")
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
        }
    }

    // MARK: - Profile Header
    private var profileHeader: some View {
        VStack(spacing: 15) {
            // Profile Photo
            if let photoURL = viewModel.user?.photoURL,
               let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
            }

            // Name and Email
            VStack(spacing: 5) {
                Text(viewModel.user?.displayName ?? viewModel.user?.email ?? "User")
                    .font(.title2)
                    .fontWeight(.bold)

                if let email = viewModel.user?.email {
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let bio = viewModel.user?.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
            }

            // Edit Profile Button
            Button(action: {
                showingEditProfile = true
            }) {
                Text("Edit Profile")
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(20)
            }
        }
        .padding()
    }

    // MARK: - Quick Stats
    private var quickStats: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Your Stats")
                    .font(.headline)

                Spacer()

                NavigationLink(destination: StatsView(viewModel: viewModel)) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                QuickStatCard(
                    icon: "figure.run",
                    value: "\(viewModel.totalActivities)",
                    label: "Activities"
                )

                QuickStatCard(
                    icon: "map",
                    value: viewModel.formattedTotalDistance,
                    label: "Distance"
                )

                QuickStatCard(
                    icon: "clock",
                    value: viewModel.formattedTotalDuration,
                    label: "Duration"
                )

                QuickStatCard(
                    icon: "arrow.up.right",
                    value: viewModel.formattedTotalElevation,
                    label: "Elevation"
                )
            }
        }
    }

    // MARK: - Menu Options
    private var menuOptions: some View {
        VStack(spacing: 15) {
            MenuButton(
                icon: "gear",
                title: "Settings",
                subtitle: "Units, privacy, and preferences"
            ) {
                showingSettings = true
            }

            MenuButton(
                icon: "arrow.down.doc",
                title: "Export Data",
                subtitle: "Download all your activities"
            ) {
                showingDataExport = true
            }

            NavigationLink(destination: StatsView(viewModel: viewModel)) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.purple)
                        .cornerRadius(10)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Statistics")
                            .font(.headline)

                        Text("View detailed stats")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    // MARK: - Danger Zone
    private var dangerZone: some View {
        VStack(spacing: 15) {
            Text("Account")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: {
                showingSignOutConfirmation = true
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Sign Out")
                    Spacer()
                }
                .foregroundColor(.orange)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            Button(action: {
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete Account")
                    Spacer()
                }
                .foregroundColor(.red)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }
}

// MARK: - Quick Stat Card
struct QuickStatCard: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .monospacedDigit()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Menu Button
struct MenuButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.accentColor)
                    .cornerRadius(10)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ProfileView(userId: "test_user")
        .environmentObject(AuthViewModel())
}
