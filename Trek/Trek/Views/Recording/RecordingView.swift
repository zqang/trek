//
//  RecordingView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

struct RecordingView: View {
    // TODO: Implement in Phase 4
    @StateObject private var locationService = LocationService()

    var body: some View {
        NavigationView {
            VStack {
                Text("Recording View")
                    .font(.title)

                Text("Implementation: Phase 4")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                // Placeholder start button
                Button(action: {}) {
                    Text("Start Activity")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 200)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }

                Spacer()
            }
            .navigationTitle("Record")
        }
    }
}

#Preview {
    RecordingView()
}
