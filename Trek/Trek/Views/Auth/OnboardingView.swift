//
//  OnboardingView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                WelcomePageView()
                    .tag(0)

                PermissionsPageView()
                    .tag(1)

                AuthSelectionView()
                    .tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
    }
}

// MARK: - Welcome Page
struct WelcomePageView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Image(systemName: "figure.run")
                .font(.system(size: 100))
                .foregroundColor(.accentColor)

            Text("Welcome to Trek")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Track your runs, rides, and outdoor activities with precision GPS tracking.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Permissions Page
struct PermissionsPageView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 30) {
                PermissionRow(
                    icon: "location.fill",
                    title: "Location Access",
                    description: "We need your location to track your activities accurately"
                )

                PermissionRow(
                    icon: "lock.fill",
                    title: "Privacy First",
                    description: "Your data is private and secure. You control what you share."
                )

                PermissionRow(
                    icon: "icloud.fill",
                    title: "Sync Everywhere",
                    description: "Your activities are backed up and synced across devices"
                )
            }

            Spacer()
        }
        .padding()
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.accentColor)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

// MARK: - Auth Selection
struct AuthSelectionView: View {
    @State private var showingLogin = false
    @State private var showingSignUp = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Get Started")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            VStack(spacing: 15) {
                Button(action: { showingSignUp = true }) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }

                Button(action: { showingLogin = true }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(12)
                }

                // TODO: Add Apple Sign In button in Phase 2
            }
            .padding(.horizontal, 30)

            Spacer()
        }
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AuthViewModel())
}
