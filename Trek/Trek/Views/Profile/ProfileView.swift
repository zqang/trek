//
//  ProfileView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ProfileView: View {
    // TODO: Implement in Phase 6
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(authViewModel.currentUser?.name ?? "User")
                                .font(.title3)
                                .fontWeight(.semibold)

                            Text(authViewModel.currentUser?.email ?? "")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.vertical, 10)
                }

                Section("Stats") {
                    StatRow(label: "Total Distance", value: "0 km")
                    StatRow(label: "Total Activities", value: "0")
                    StatRow(label: "Total Time", value: "0:00")
                }

                Section {
                    NavigationLink(destination: Text("Settings")) {
                        Label("Settings", systemImage: "gear")
                    }

                    Button(action: { authViewModel.signOut() }) {
                        Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
