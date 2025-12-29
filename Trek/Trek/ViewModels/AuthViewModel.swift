//
//  AuthViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import Combine

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
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = nil

        do {
            try await authService.resetPassword(email: email)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Apple Sign In
    func signInWithApple() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await authService.signInWithApple()
            isNewUser = result.isNewUser

            if result.isNewUser {
                // Show profile setup for new users
                showProfileSetup = true
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Update Profile Photo
    func updateProfilePhoto(_ image: UIImage) async {
        guard let userId = currentUser?.id else { return }

        isLoading = true
        errorMessage = nil

        do {
            let photoURL = try await storageService.uploadProfilePhoto(userId: userId, image: image)
            try await authService.updateUserProfile(name: nil, profilePhotoURL: photoURL)
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
            var photoURL: String?
            if let photo = photo, let userId = currentUser?.id {
                photoURL = try await storageService.uploadProfilePhoto(userId: userId, image: photo)
            }

            try await authService.updateUserProfile(name: name, profilePhotoURL: photoURL)
            showProfileSetup = false
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
