//
//  ProfileViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import SwiftUI
import os.log

private let logger = Logger(subsystem: "com.trek", category: "ProfileViewModel")

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
    private let activityService = ActivityService()
    private let coreData = CoreDataStack.shared

    let userId: String

    init(userId: String) {
        self.userId = userId
    }

    // MARK: - Fetch User Profile

    func fetchUserProfile() async {
        isLoading = true

        guard let uuid = UUID(uuidString: userId) else {
            errorMessage = "Invalid user ID"
            showingError = true
            isLoading = false
            return
        }

        do {
            let context = coreData.viewContext
            let request = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

            if let userEntity = try context.fetch(request).first {
                let user = User(entity: userEntity)
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
        guard let uuid = UUID(uuidString: userId) else { return }

        do {
            let context = coreData.viewContext
            let request = ActivityEntity.fetchRequest()
            request.predicate = NSPredicate(format: "userId == %@", uuid as CVarArg)

            let entities = try context.fetch(request)

            totalActivities = entities.count
            totalDistance = 0
            totalDuration = 0
            totalElevationGain = 0
            activitiesByType = [:]

            for entity in entities {
                totalDistance += entity.distance
                totalDuration += entity.duration
                totalElevationGain += entity.elevationGain

                // Count by type
                if let typeString = entity.type,
                   let activityType = ActivityType(rawValue: typeString) {
                    activitiesByType[activityType, default: 0] += 1
                }
            }
        } catch {
            logger.error("Error fetching user stats: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Profile

    func updateProfile() async -> Bool {
        guard var updatedUser = user,
              let uuid = UUID(uuidString: userId) else { return false }

        isSaving = true

        do {
            // Upload profile photo if selected
            if let profileImage = selectedProfileImage {
                let photoPath = try await storageService.uploadProfilePhoto(
                    userId: userId,
                    image: profileImage
                )
                updatedUser.photoURL = photoPath
                updatedUser.profilePhotoURL = photoPath
            }

            // Update user fields
            updatedUser.displayName = editedDisplayName.trimmingCharacters(in: .whitespaces)
            updatedUser.bio = editedBio.trimmingCharacters(in: .whitespaces)

            // Save to Core Data
            let context = coreData.viewContext
            let request = UserEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

            if let userEntity = try context.fetch(request).first {
                userEntity.name = updatedUser.name
                userEntity.bio = updatedUser.bio
                userEntity.profilePhotoPath = updatedUser.profilePhotoURL

                context.updateUser(userEntity)
                try context.save()
            }

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
        guard let uuid = UUID(uuidString: userId) else { return false }

        do {
            let context = coreData.viewContext

            // Delete all user activities
            let activitiesRequest = ActivityEntity.fetchRequest()
            activitiesRequest.predicate = NSPredicate(format: "userId == %@", uuid as CVarArg)
            let activities = try context.fetch(activitiesRequest)
            for activity in activities {
                context.deleteActivity(activity)
            }

            // Delete user
            let userRequest = UserEntity.fetchRequest()
            userRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            if let userEntity = try context.fetch(userRequest).first {
                context.deleteUser(userEntity)
            }

            try context.save()

            // Delete stored files
            try await storageService.deleteAllUserData(userId: userId)

            // Clear session
            try authService.signOut()

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
