//
//  TrekApp.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI
import FirebaseCore

@main
struct TrekApp: App {

    init() {
        // Configure Firebase
        FirebaseApp.configure()

        // Enable Firestore offline persistence
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
