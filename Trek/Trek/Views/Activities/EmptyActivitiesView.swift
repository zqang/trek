//
//  EmptyActivitiesView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct EmptyActivitiesView: View {
    let hasFilters: Bool
    let onStartRecording: () -> Void
    let onClearFilters: () -> Void

    var body: some View {
        VStack(spacing: 25) {
            Spacer()

            if hasFilters {
                // No results with filters applied
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 70))
                    .foregroundColor(.gray)

                Text("No Activities Found")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Try adjusting your filters or search terms")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: onClearFilters) {
                    Text("Clear Filters")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
            } else {
                // No activities at all
                Image(systemName: "figure.run")
                    .font(.system(size: 70))
                    .foregroundColor(.gray)

                Text("No Activities Yet")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Start your first activity to see it here. Your journey begins with a single step!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: onStartRecording) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Start Recording")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
                }
            }

            Spacer()
        }
    }
}

#Preview {
    VStack {
        EmptyActivitiesView(
            hasFilters: false,
            onStartRecording: {},
            onClearFilters: {}
        )

        Divider()

        EmptyActivitiesView(
            hasFilters: true,
            onStartRecording: {},
            onClearFilters: {}
        )
    }
}
