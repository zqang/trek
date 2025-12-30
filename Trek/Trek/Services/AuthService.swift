//
//  AuthService.swift
//  Trek
//
//  Local authentication service using local storage and Keychain.
//  Passwords are hashed using SHA256 with salt for security.
//

import Foundation
import Security
import CryptoKit
import os.log

private let logger = Logger(subsystem: "com.trek", category: "AuthService")

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false

    private let coreData = CoreDataStack.shared
    private let keychainService = "com.trek.auth"
    private let saltKeychainService = "com.trek.auth.salt"

    init() {
        loadSavedSession()
    }

    // MARK: - Password Hashing

    private func generateSalt() -> Data {
        var bytes = [UInt8](repeating: 0, count: 32)
        _ = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        return Data(bytes)
    }

    private func hashPassword(_ password: String, salt: Data) -> String {
        let passwordData = Data(password.utf8)
        var combinedData = salt
        combinedData.append(passwordData)

        let hash = SHA256.hash(data: combinedData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Validation

    private func validateEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }

    private func validatePassword(_ password: String) -> Bool {
        // Minimum 6 characters
        return password.count >= 6
    }

    private func validateName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 1 && trimmed.count <= 100
    }

    // MARK: - Sign Up

    func signUp(email: String, password: String, name: String) async throws {
        // Validate inputs
        guard validateEmail(email) else {
            throw AuthError.invalidEmail
        }
        guard validatePassword(password) else {
            throw AuthError.weakPassword
        }
        guard validateName(name) else {
            throw AuthError.invalidName
        }

        let context = coreData.viewContext

        // Check if email already exists
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email.lowercased())
        let existing = try context.fetch(request)

        if !existing.isEmpty {
            throw AuthError.emailAlreadyInUse
        }

        // Create new user
        let userEntity = UserEntity()
        let userId = UUID()
        userEntity.id = userId
        userEntity.email = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        userEntity.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        userEntity.createdAt = Date()
        userEntity.preferredUnits = "metric"
        userEntity.totalDistance = 0
        userEntity.totalActivities = 0
        userEntity.totalDuration = 0

        context.addUser(userEntity)

        // Generate salt and hash password
        let salt = generateSalt()
        let hashedPassword = hashPassword(password, salt: salt)

        // Save salt and hashed password to Keychain
        try saveToKeychain(userId: userId.uuidString, hashedPassword: hashedPassword, salt: salt)

        try context.save()

        logger.info("User created successfully: \(userId.uuidString)")

        // Set current user
        let user = User(entity: userEntity)
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }

        saveSession(userId: userId.uuidString)
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) async throws {
        guard validateEmail(email) else {
            throw AuthError.invalidEmail
        }

        let context = coreData.viewContext

        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email.lowercased())
        let results = try context.fetch(request)

        guard let userEntity = results.first,
              let userId = userEntity.id?.uuidString else {
            logger.warning("Sign in failed: user not found for email")
            throw AuthError.invalidCredentials
        }

        // Verify password
        guard try verifyPassword(userId: userId, password: password) else {
            logger.warning("Sign in failed: invalid password for user \(userId)")
            throw AuthError.invalidCredentials
        }

        let user = User(entity: userEntity)
        await MainActor.run {
            self.currentUser = user
            self.isAuthenticated = true
        }

        logger.info("User signed in successfully: \(userId)")
        saveSession(userId: userId)
    }

    // MARK: - Sign Out

    func signOut() throws {
        let userId = currentUser?.id
        clearSession()
        isAuthenticated = false
        currentUser = nil
        logger.info("User signed out: \(userId ?? "unknown")")
    }

    // MARK: - Password Reset

    func resetPassword(email: String, newPassword: String) async throws {
        guard validateEmail(email) else {
            throw AuthError.invalidEmail
        }
        guard validatePassword(newPassword) else {
            throw AuthError.weakPassword
        }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@", email.lowercased())
        let results = try context.fetch(request)

        guard let userEntity = results.first,
              let userId = userEntity.id?.uuidString else {
            throw AuthError.userNotFound
        }

        // Generate new salt and hash
        let salt = generateSalt()
        let hashedPassword = hashPassword(newPassword, salt: salt)

        // Update keychain
        deleteFromKeychain(userId: userId)
        try saveToKeychain(userId: userId, hashedPassword: hashedPassword, salt: salt)

        logger.info("Password reset for user: \(userId)")
    }

    // MARK: - Update Password

    func updatePassword(currentPassword: String, newPassword: String) async throws {
        guard let userId = currentUser?.id else {
            throw AuthError.notAuthenticated
        }

        guard validatePassword(newPassword) else {
            throw AuthError.weakPassword
        }

        guard try verifyPassword(userId: userId, password: currentPassword) else {
            throw AuthError.invalidCredentials
        }

        // Generate new salt and hash
        let salt = generateSalt()
        let hashedPassword = hashPassword(newPassword, salt: salt)

        // Update keychain
        deleteFromKeychain(userId: userId)
        try saveToKeychain(userId: userId, hashedPassword: hashedPassword, salt: salt)

        logger.info("Password updated for user: \(userId)")
    }

    // MARK: - Update User Profile

    func updateUserProfile(name: String?, profilePhotoURL: String?) async throws {
        guard let userId = currentUser?.id,
              let uuid = UUID(uuidString: userId) else {
            throw AuthError.notAuthenticated
        }

        if let name = name, !validateName(name) {
            throw AuthError.invalidName
        }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        let results = try context.fetch(request)

        guard let userEntity = results.first else {
            throw AuthError.userNotFound
        }

        if let name = name {
            userEntity.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if let photoURL = profilePhotoURL {
            userEntity.profilePhotoPath = photoURL
        }

        context.updateUser(userEntity)
        try context.save()

        await MainActor.run {
            self.currentUser = User(entity: userEntity)
        }

        logger.info("Profile updated for user: \(userId)")
    }

    // MARK: - Delete Account

    func deleteAccount() async throws {
        guard let userId = currentUser?.id,
              let uuid = UUID(uuidString: userId) else {
            throw AuthError.notAuthenticated
        }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        let results = try context.fetch(request)

        if let userEntity = results.first {
            context.deleteUser(userEntity)
            try context.save()
        }

        // Remove from keychain
        deleteFromKeychain(userId: userId)
        clearSession()

        await MainActor.run {
            self.isAuthenticated = false
            self.currentUser = nil
        }

        logger.info("Account deleted: \(userId)")
    }

    // MARK: - Session Management

    private func saveSession(userId: String) {
        UserDefaults.standard.set(userId, forKey: "currentUserId")
    }

    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
    }

    private func loadSavedSession() {
        guard let userId = UserDefaults.standard.string(forKey: "currentUserId"),
              let uuid = UUID(uuidString: userId) else { return }

        let context = coreData.viewContext
        let request = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        do {
            let results = try context.fetch(request)
            if let userEntity = results.first {
                self.currentUser = User(entity: userEntity)
                self.isAuthenticated = true
                logger.info("Session restored for user: \(userId)")
            }
        } catch {
            logger.error("Failed to load session: \(error.localizedDescription)")
            clearSession()
        }
    }

    // MARK: - Keychain Operations

    private func saveToKeychain(userId: String, hashedPassword: String, salt: Data) throws {
        guard let passwordData = hashedPassword.data(using: .utf8) else {
            throw AuthError.keychainError
        }

        // Delete existing entries first
        deleteFromKeychain(userId: userId)

        // Save hashed password
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: userId,
            kSecValueData as String: passwordData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        var status = SecItemAdd(passwordQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            logger.error("Failed to save password to keychain: \(status)")
            throw AuthError.keychainError
        }

        // Save salt
        let saltQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: saltKeychainService,
            kSecAttrAccount as String: userId,
            kSecValueData as String: salt,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        status = SecItemAdd(saltQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            logger.error("Failed to save salt to keychain: \(status)")
            throw AuthError.keychainError
        }
    }

    private func verifyPassword(userId: String, password: String) throws -> Bool {
        // Get salt
        let saltQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: saltKeychainService,
            kSecAttrAccount as String: userId,
            kSecReturnData as String: true
        ]

        var saltResult: AnyObject?
        var status = SecItemCopyMatching(saltQuery as CFDictionary, &saltResult)

        guard status == errSecSuccess,
              let salt = saltResult as? Data else {
            // For backwards compatibility with existing plain-text passwords
            // Try legacy verification
            return try verifyLegacyPassword(userId: userId, password: password)
        }

        // Get stored hash
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: userId,
            kSecReturnData as String: true
        ]

        var passwordResult: AnyObject?
        status = SecItemCopyMatching(passwordQuery as CFDictionary, &passwordResult)

        guard status == errSecSuccess,
              let data = passwordResult as? Data,
              let storedHash = String(data: data, encoding: .utf8) else {
            return false
        }

        // Hash provided password with stored salt and compare
        let computedHash = hashPassword(password, salt: salt)
        return storedHash == computedHash
    }

    // Legacy support for existing plain-text passwords (migration)
    private func verifyLegacyPassword(userId: String, password: String) throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: userId,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let storedPassword = String(data: data, encoding: .utf8) else {
            return false
        }

        // Check if it's a plain text match (legacy)
        if storedPassword == password {
            // Migrate to hashed password
            logger.info("Migrating legacy password for user: \(userId)")
            let salt = generateSalt()
            let hashedPassword = hashPassword(password, salt: salt)
            deleteFromKeychain(userId: userId)
            try saveToKeychain(userId: userId, hashedPassword: hashedPassword, salt: salt)
            return true
        }

        return false
    }

    private func deleteFromKeychain(userId: String) {
        // Delete password
        let passwordQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: userId
        ]
        SecItemDelete(passwordQuery as CFDictionary)

        // Delete salt
        let saltQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: saltKeychainService,
            kSecAttrAccount as String: userId
        ]
        SecItemDelete(saltQuery as CFDictionary)
    }
}

// MARK: - Auth Errors

enum AuthError: LocalizedError {
    case emailAlreadyInUse
    case invalidCredentials
    case userNotFound
    case notAuthenticated
    case keychainError
    case invalidEmail
    case weakPassword
    case invalidName

    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse:
            return "This email is already registered"
        case .invalidCredentials:
            return "Invalid email or password"
        case .userNotFound:
            return "No account found with this email"
        case .notAuthenticated:
            return "You must be signed in"
        case .keychainError:
            return "Failed to save credentials securely"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .weakPassword:
            return "Password must be at least 6 characters"
        case .invalidName:
            return "Please enter a valid name"
        }
    }
}
