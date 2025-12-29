//
//  DataExportView.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import FirebaseFirestore

struct DataExportView: View {
    @Environment(\.dismiss) var dismiss
    let userId: String

    @State private var isExporting = false
    @State private var exportProgress: Double = 0
    @State private var exportStatus: String = ""
    @State private var showingError = false
    @State private var errorMessage: String?
    @State private var exportedFileURL: URL?

    private let activityService = ActivityService()

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header Icon
                Image(systemName: "arrow.down.doc")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)

                // Title and Description
                VStack(spacing: 10) {
                    Text("Export Your Data")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Download all your activities as GPX files in a ZIP archive. This includes your complete activity history with GPS data.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                // Export Progress
                if isExporting {
                    VStack(spacing: 15) {
                        ProgressView(value: exportProgress, total: 1.0)
                            .padding(.horizontal, 40)

                        Text(exportStatus)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // Export Button
                if !isExporting {
                    Button(action: exportData) {
                        HStack {
                            Image(systemName: "arrow.down.circle")
                            Text("Export All Activities")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                    }
                } else {
                    Button("Cancel") {
                        isExporting = false
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                }

                // GDPR Notice
                Text("This export includes all your personal data stored in Trek, in compliance with GDPR regulations.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
            .navigationTitle("Data Export")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Export Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
        }
    }

    // MARK: - Export Data
    private func exportData() {
        isExporting = true
        exportProgress = 0
        exportStatus = "Fetching activities..."

        Task {
            do {
                // Fetch all activities
                var allActivities: [Activity] = []
                var lastDoc: DocumentSnapshot?
                var hasMore = true

                while hasMore {
                    let (activities, lastDocument) = try await activityService.fetchActivities(
                        userId: userId,
                        limit: 50,
                        lastDocument: lastDoc
                    )

                    allActivities.append(contentsOf: activities)
                    lastDoc = lastDocument
                    hasMore = activities.count == 50

                    exportProgress = 0.3
                    exportStatus = "Fetched \(allActivities.count) activities..."
                }

                guard !allActivities.isEmpty else {
                    errorMessage = "No activities to export"
                    showingError = true
                    isExporting = false
                    return
                }

                exportProgress = 0.4
                exportStatus = "Generating GPX files..."

                // Create temporary directory for GPX files
                let tempDir = FileManager.default.temporaryDirectory
                    .appendingPathComponent("trek_export_\(UUID().uuidString)")
                try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)

                // Generate GPX files
                for (index, activity) in allActivities.enumerated() {
                    let gpxString = activityService.exportActivityAsGPX(activity)

                    // Sanitize filename
                    let sanitizedName = activity.name
                        .replacingOccurrences(of: "/", with: "-")
                        .replacingOccurrences(of: ":", with: "-")

                    let filename = "\(activity.startTime.formatted(date: .numeric, time: .omitted))_\(sanitizedName).gpx"
                    let fileURL = tempDir.appendingPathComponent(filename)

                    try gpxString.write(to: fileURL, atomically: true, encoding: .utf8)

                    exportProgress = 0.4 + (0.4 * Double(index + 1) / Double(allActivities.count))
                    exportStatus = "Exported \(index + 1) of \(allActivities.count) activities..."
                }

                exportProgress = 0.9
                exportStatus = "Preparing to share..."

                // Share the directory containing all GPX files
                exportProgress = 1.0
                exportStatus = "Export complete!"

                await MainActor.run {
                    shareFolder(tempDir)
                    isExporting = false
                }

            } catch {
                errorMessage = error.localizedDescription
                showingError = true
                isExporting = false
            }
        }
    }

    // MARK: - Share Folder
    private func shareFolder(_ url: URL) {
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        // Clean up after sharing
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            try? FileManager.default.removeItem(at: url)
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    DataExportView(userId: "test_user")
}
