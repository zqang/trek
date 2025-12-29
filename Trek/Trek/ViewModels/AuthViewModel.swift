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

    private let authService = AuthService()
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
}
