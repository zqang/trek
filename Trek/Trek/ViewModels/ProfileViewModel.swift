//
//  ProfileViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var isLoading = false
    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var showingError = false

    // User stats
    @Published var totalActivities = 0
    @Published var totalDistance: Double = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var totalElevationGain: Double = 0
    @Published var activitiesByType: [ActivityType: Int] = [:]

    // Edit fields
    @Published var editedDisplayName: String = ""
    @Published var editedBio: String = ""
    @Published var selectedProfileImage: UIImage?

    private let authService = AuthService()
    private let storageService = StorageService()
    private let db = Firestore.firestore()

    let userId: String

    init(userId: String) {
        self.userId = userId
    }

    // MARK: - Fetch User Profile

    func fetchUserProfile() async {
        isLoading = true

        do {
            let document = try await db.collection("users").document(userId).getDocument()

            if let user = try? document.data(as: User.self) {
                self.user = user
                self.editedDisplayName = user.displayName ?? ""
                self.editedBio = user.bio ?? ""

                // Fetch user stats
                await fetchUserStats()
            } else {
                errorMessage = "Failed to load user profile"
                showingError = true
            }

            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isLoading = false
        }
    }

    // MARK: - Fetch User Stats

    private func fetchUserStats() async {
        do {
            let snapshot = try await db.collection("activities")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()

            totalActivities = snapshot.documents.count
            totalDistance = 0
            totalDuration = 0
            totalElevationGain = 0
            activitiesByType = [:]

            for document in snapshot.documents {
                if let activity = try? document.data(as: Activity.self) {
                    totalDistance += activity.distance
                    totalDuration += activity.duration
                    totalElevationGain += activity.elevationGain

                    // Count by type
                    activitiesByType[activity.type, default: 0] += 1
                }
            }
        } catch {
            print("Error fetching user stats: \(error)")
        }
    }

    // MARK: - Update Profile

    func updateProfile() async -> Bool {
        guard var updatedUser = user else { return false }

        isSaving = true

        do {
            // Upload profile photo if selected
            if let profileImage = selectedProfileImage {
                let photoURL = try await storageService.uploadProfilePhoto(
                    userId: userId,
                    image: profileImage
                )
                updatedUser.photoURL = photoURL
            }

            // Update user fields
            updatedUser.displayName = editedDisplayName.trimmingCharacters(in: .whitespaces)
            updatedUser.bio = editedBio.trimmingCharacters(in: .whitespaces)

            // Save to Firestore
            try db.collection("users").document(userId).setData(from: updatedUser, merge: true)

            // Update local copy
            self.user = updatedUser

            isSaving = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            isSaving = false
            return false
        }
    }

    // MARK: - Sign Out

    func signOut() throws {
        try authService.signOut()
    }

    // MARK: - Delete Account

    func deleteAccount() async -> Bool {
        do {
            // Delete all user activities
            let activitiesSnapshot = try await db.collection("activities")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()

            // Batch delete activities
            let batch = db.batch()
            for document in activitiesSnapshot.documents {
                batch.deleteDocument(document.reference)
            }
            try await batch.commit()

            // Delete user document
            try await db.collection("users").document(userId).delete()

            // Delete Firebase Auth account
            if let currentUser = Auth.auth().currentUser {
                try await currentUser.delete()
            }

            return true
        } catch {
            errorMessage = "Failed to delete account: \(error.localizedDescription)"
            showingError = true
            return false
        }
    }

    // MARK: - Computed Properties

    var formattedTotalDistance: String {
        Formatters.formatDistance(totalDistance, unit: .metric)
    }

    var formattedTotalDuration: String {
        totalDuration.formattedDuration
    }

    var formattedTotalElevation: String {
        Formatters.formatElevation(totalElevationGain, unit: .metric)
    }

    var averageDistance: Double {
        guard totalActivities > 0 else { return 0 }
        return totalDistance / Double(totalActivities)
    }

    var formattedAverageDistance: String {
        Formatters.formatDistance(averageDistance, unit: .metric)
    }

    var averageDuration: TimeInterval {
        guard totalActivities > 0 else { return 0 }
        return totalDuration / Double(totalActivities)
    }

    var formattedAverageDuration: String {
        averageDuration.formattedDuration
    }

    var mostCommonActivityType: ActivityType? {
        activitiesByType.max(by: { $0.value < $1.value })?.key
    }
}
