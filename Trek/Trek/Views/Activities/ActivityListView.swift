//
//  ActivityListView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct ActivityListView: View {
    // TODO: Implement in Phase 5
    @State private var activities: [Activity] = []

    var body: some View {
        NavigationView {
            Group {
                if activities.isEmpty {
                    EmptyActivitiesView()
                } else {
                    List(activities) { activity in
                        Text(activity.displayName)
                    }
                }
            }
            .navigationTitle("Activities")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

// MARK: - Empty State
struct EmptyActivitiesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "figure.run.circle")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            Text("No Activities Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap the + button below to record your first activity")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }
}

#Preview {
    ActivityListView()
}
