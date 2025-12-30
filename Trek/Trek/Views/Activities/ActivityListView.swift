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
                    EmptyActivitiesView(
                        hasFilters: false,
                        onStartRecording: {},
                        onClearFilters: {}
                    )
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

#Preview {
    ActivityListView()
}
