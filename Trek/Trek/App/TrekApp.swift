//
//  TrekApp.swift
//  Trek
//
//  Created on December 29, 2025.
//

import SwiftUI

@main
struct TrekApp: App {

    init() {
        // Initialize Core Data stack
        _ = CoreDataStack.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
