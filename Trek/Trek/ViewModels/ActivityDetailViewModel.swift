//
//  ActivityDetailViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation

@MainActor
class ActivityDetailViewModel: ObservableObject {
    @Published var activity: Activity
    @Published var isEditing = false
    @Published var isSaving = false
    @Published var isDeleting = false
    @Published var showingError = false
    @Published var errorMessage: String?

    // Editable fields
    @Published var editedName: String
    @Published var editedType: ActivityType
    @Published var editedIsPrivate: Bool

    private let activityService = ActivityService()
    private let originalActivity: Activity

    init(activity: Activity) {
        self.activity = activity
        self.originalActivity = activity
        self.editedName = activity.name
        self.editedType = activity.type
        self.editedIsPrivate = activity.isPrivate
    }

    // MARK: - Edit Mode

    func startEditing() {
        isEditing = true
    }

    func cancelEditing() {
        // Restore original values
        editedName = activity.name
        editedType = activity.type
        editedIsPrivate = activity.isPrivate
        isEditing = false
    }

    func saveChanges() async -> Bool {
        guard hasChanges else {
            isEditing = false
            return true
        }

        guard !editedName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Activity name cannot be empty"
            showingError = true
            return false
        }

        isSaving = true

        do {
            // Update activity
            var updatedActivity = activity
            updatedActivity.name = editedName.trimmingCharacters(in: .whitespaces)
            updatedActivity.type = editedType
            updatedActivity.isPrivate = editedIsPrivate

            try await activityService.updateActivity(updatedActivity)

            // Update local copy
            activity = updatedActivity

            isSaving = false
            isEditing = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isSaving = false
            return false
        }
    }

    // MARK: - Delete Activity

    func deleteActivity() async -> Bool {
        guard let activityId = activity.id else {
            errorMessage = "Invalid activity"
            showingError = true
            return false
        }

        isDeleting = true

        do {
            try await activityService.deleteActivity(id: activityId, userId: activity.userId)
            isDeleting = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isDeleting = false
            return false
        }
    }

    // MARK: - Export

    func exportAsGPX() -> String {
        return activityService.exportActivityAsGPX(activity)
    }

    func shareGPX() {
        let gpxString = exportAsGPX()

        // Create temporary file
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(activity.name).gpx")

        do {
            try gpxString.write(to: tempURL, atomically: true, encoding: .utf8)

            // Share using UIActivityViewController
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                let activityVC = UIActivityViewController(
                    activityItems: [tempURL],
                    applicationActivities: nil
                )
                rootViewController.present(activityVC, animated: true)
            }
        } catch {
            errorMessage = "Failed to export activity: \(error.localizedDescription)"
            showingError = true
        }
    }

    // MARK: - Helpers

    var hasChanges: Bool {
        editedName != activity.name ||
        editedType != activity.type ||
        editedIsPrivate != activity.isPrivate
    }

    var formattedDate: String {
        activity.startTime.formatted(date: .long, time: .shortened)
    }

    var formattedDuration: String {
        activity.duration.formattedDuration
    }

    var formattedDistance: String {
        Formatters.formatDistance(activity.distance, unit: .metric)
    }

    var formattedPace: String {
        Formatters.formatPace(activity.averagePace, unit: .metric)
    }

    var formattedSpeed: String {
        Formatters.formatSpeed(activity.averageSpeed / 3.6, unit: .metric)
    }

    var formattedElevation: String {
        Formatters.formatElevation(activity.elevationGain, unit: .metric)
    }

    var averageHeartRate: Int? {
        // TODO: Implement when heart rate data is added
        return nil
    }

    var calories: Int? {
        // TODO: Implement calorie calculation
        return nil
    }
}
