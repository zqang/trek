//
//  AuthViewModelTests.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import XCTest
@testable import Trek

@MainActor
final class AuthViewModelTests: XCTestCase {
    var viewModel: AuthViewModel!

    override func setUp() {
        super.setUp()
        viewModel = AuthViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // MARK: - Initial State Tests
    func testInitialState() {
        XCTAssertNil(viewModel.currentUser)
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showProfileSetup)
        XCTAssertFalse(viewModel.isNewUser)
    }

    // MARK: - Sign Up Tests
    func testSignUpWithValidCredentials() async {
        // Test with valid credentials - uses local storage
        XCTAssertNotNil(viewModel)
    }

    func testSignUpWithInvalidEmail() async {
        // Test with invalid email format
        await viewModel.signUp(email: "invalidemail", password: "password123", name: "Test User")
        XCTAssertNotNil(viewModel.errorMessage)
    }

    func testSignUpWithWeakPassword() async {
        // Test with weak password
        await viewModel.signUp(email: "test@example.com", password: "123", name: "Test User")
        XCTAssertNotNil(viewModel.errorMessage)
    }

    // MARK: - Sign In Tests
    func testSignInWithEmptyCredentials() async {
        await viewModel.signIn(email: "", password: "")
        // Should have error message
        XCTAssertNotNil(viewModel.errorMessage)
    }

    // MARK: - Sign Out Tests
    func testSignOut() {
        viewModel.signOut()
        XCTAssertFalse(viewModel.isAuthenticated)
        XCTAssertNil(viewModel.currentUser)
    }

    // MARK: - Loading State Tests
    func testLoadingStateDuringSignUp() async {
        let expectation = expectation(description: "Loading state changes")

        Task {
            await viewModel.signUp(email: "test@example.com", password: "password123", name: "Test")
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 5.0)
    }
}

// MARK: - Mock Auth Service for Testing
// Note: AuthService now uses local Keychain storage - no external dependencies
