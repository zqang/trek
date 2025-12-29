//
//  AuthService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    init() {
        // Listen for auth state changes
        auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                Task {
                    await self?.fetchUser(userId: user.uid)
                }
            } else {
                self?.isAuthenticated = false
                self?.currentUser = nil
            }
        }
    }

    // MARK: - Sign Up
    func signUp(email: String, password: String, name: String) async throws {
        let result = try await auth.createUser(withEmail: email, password: password)

        // Create user document in Firestore
        let newUser = User(
            id: result.user.uid,
            email: email,
            name: name,
            profilePhotoURL: nil,
            totalDistance: 0,
            totalActivities: 0,
            totalDuration: 0,
            preferredUnits: .metric,
            createdAt: Date()
        )

        try await createUser(newUser)
    }

    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut()
        isAuthenticated = false
        currentUser = nil
    }

    // MARK: - Password Reset
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }

    // MARK: - Apple Sign In
    // TODO: Implement Apple Sign In in Phase 2

    // MARK: - Firestore Operations
    private func createUser(_ user: User) async throws {
        guard let userId = user.id else {
            throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User ID is nil"])
        }

        try db.collection("users").document(userId).setData(from: user)
        self.currentUser = user
        self.isAuthenticated = true
    }

    private func fetchUser(userId: String) async {
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            self.currentUser = try document.data(as: User.self)
            self.isAuthenticated = true
        } catch {
            print("Error fetching user: \(error.localizedDescription)")
            self.isAuthenticated = false
        }
    }

    // MARK: - Update User Profile
    func updateUserProfile(name: String?, profilePhotoURL: String?) async throws {
        guard let userId = currentUser?.id else { return }

        var updates: [String: Any] = [:]
        if let name = name {
            updates["name"] = name
        }
        if let photoURL = profilePhotoURL {
            updates["profilePhotoURL"] = photoURL
        }

        try await db.collection("users").document(userId).updateData(updates)

        // Update local user
        await fetchUser(userId: userId)
    }

    // MARK: - Delete Account
    func deleteAccount() async throws {
        guard let userId = currentUser?.id else { return }
        guard let user = auth.currentUser else { return }

        // Delete user data from Firestore (will be handled by Cloud Function)
        try await db.collection("users").document(userId).delete()

        // Delete auth account
        try await user.delete()

        isAuthenticated = false
        currentUser = nil
    }
}
