//
//  ContentView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                OnboardingView()
                    .environmentObject(authViewModel)
            }
        }
        .sheet(isPresented: $authViewModel.showProfileSetup) {
            ProfileSetupView()
                .environmentObject(authViewModel)
                .interactiveDismissDisabled(false)
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        ZStack(alignment: .top) {
            TabView {
            if let userId = authViewModel.currentUser?.id {
                ActivitiesListView(userId: userId)
                    .tabItem {
                        Label("Activities", systemImage: "list.bullet")
                    }
            } else {
                Text("Loading...")
                    .tabItem {
                        Label("Activities", systemImage: "list.bullet")
                    }
            }

            RecordingView()
                .tabItem {
                    Label("Record", systemImage: "plus.circle.fill")
                }

            if let userId = authViewModel.currentUser?.id {
                ProfileView(userId: userId)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            } else {
                Text("Loading...")
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
            }
            }

            // Network Status Banner
            NetworkStatusBanner()
        }
    }
}

#Preview {
    ContentView()
}
