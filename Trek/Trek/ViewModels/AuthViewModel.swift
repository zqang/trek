//
//  AuthViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Combine
import UIKit

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showProfileSetup = false
    @Published var isNewUser = false

    private let authService = AuthService()
    private let storageService = StorageService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observe auth state from service
        authService.$isAuthenticated
            .assign(to: &$isAuthenticated)

        authService.$currentUser
            .assign(to: &$currentUser)
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signUp(email: email, password: password, name: name)
            isNewUser = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Sign Out
    func signOut() {
        do {
            try authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Password Reset
    // Note: For local-only apps, password reset requires direct access to the app
    // This method shows an informational message
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil

        // For local auth, we can only show a message since there's no email verification
        errorMessage = "Password reset is not available for local accounts. Please contact support if you've forgotten your password."

        isLoading = false
    }

    // MARK: - Update Password (for authenticated users)
    func updatePassword(currentPassword: String, newPassword: String) async -> Bool {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.updatePassword(currentPassword: currentPassword, newPassword: newPassword)
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Update Profile Photo
    func updateProfilePhoto(_ image: UIImage) async {
        guard let userId = currentUser?.id else { return }

        isLoading = true
        errorMessage = nil

        do {
            let photoPath = try await storageService.uploadProfilePhoto(userId: userId, image: image)
            try await authService.updateUserProfile(name: nil, profilePhotoURL: photoPath)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Complete Profile Setup
    func completeProfileSetup(name: String?, photo: UIImage?) async {
        isLoading = true
        errorMessage = nil

        do {
            var photoPath: String?
            if let photo = photo, let userId = currentUser?.id {
                photoPath = try await storageService.uploadProfilePhoto(userId: userId, image: photo)
            }

            try await authService.updateUserProfile(name: name, profilePhotoURL: photoPath)
            showProfileSetup = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
