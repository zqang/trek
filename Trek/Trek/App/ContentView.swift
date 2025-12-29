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
            } else {
                OnboardingView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            ActivityListView()
                .tabItem {
                    Label("Activities", systemImage: "list.bullet")
                }

            RecordingView()
                .tabItem {
                    Label("Record", systemImage: "plus.circle.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
