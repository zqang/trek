//
//  SettingsViewModel.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    // User Defaults keys
    private enum Keys {
        static let unitSystem = "unitSystem"
        static let defaultActivityPrivacy = "defaultActivityPrivacy"
        static let autoSaveInterval = "autoSaveInterval"
        static let showGPSAccuracy = "showGPSAccuracy"
        static let enableNotifications = "enableNotifications"
    }

    // Settings
    @Published var unitSystem: UnitSystem {
        didSet {
            UserDefaults.standard.set(unitSystem.rawValue, forKey: Keys.unitSystem)
        }
    }

    @Published var defaultActivityPrivacy: Bool {
        didSet {
            UserDefaults.standard.set(defaultActivityPrivacy, forKey: Keys.defaultActivityPrivacy)
        }
    }

    @Published var autoSaveInterval: Int {
        didSet {
            UserDefaults.standard.set(autoSaveInterval, forKey: Keys.autoSaveInterval)
        }
    }

    @Published var showGPSAccuracy: Bool {
        didSet {
            UserDefaults.standard.set(showGPSAccuracy, forKey: Keys.showGPSAccuracy)
        }
    }

    @Published var enableNotifications: Bool {
        didSet {
            UserDefaults.standard.set(enableNotifications, forKey: Keys.enableNotifications)
        }
    }

    // App info
    let appVersion: String
    let buildNumber: String

    init() {
        // Load settings from UserDefaults
        if let unitSystemRaw = UserDefaults.standard.string(forKey: Keys.unitSystem),
           let savedUnitSystem = UnitSystem(rawValue: unitSystemRaw) {
            self.unitSystem = savedUnitSystem
        } else {
            self.unitSystem = .metric
        }

        self.defaultActivityPrivacy = UserDefaults.standard.bool(forKey: Keys.defaultActivityPrivacy)

        let savedInterval = UserDefaults.standard.integer(forKey: Keys.autoSaveInterval)
        self.autoSaveInterval = savedInterval > 0 ? savedInterval : 30

        self.showGPSAccuracy = UserDefaults.standard.bool(forKey: Keys.showGPSAccuracy)
        self.enableNotifications = UserDefaults.standard.bool(forKey: Keys.enableNotifications)

        // App version info
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        self.buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    // MARK: - Reset Settings

    func resetToDefaults() {
        unitSystem = .metric
        defaultActivityPrivacy = false
        autoSaveInterval = 30
        showGPSAccuracy = false
        enableNotifications = false
    }

    // MARK: - Clear Cache

    func clearCache() {
        // Clear UserDefaults (except settings)
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }

        // Re-save current settings
        UserDefaults.standard.set(unitSystem.rawValue, forKey: Keys.unitSystem)
        UserDefaults.standard.set(defaultActivityPrivacy, forKey: Keys.defaultActivityPrivacy)
        UserDefaults.standard.set(autoSaveInterval, forKey: Keys.autoSaveInterval)
        UserDefaults.standard.set(showGPSAccuracy, forKey: Keys.showGPSAccuracy)
        UserDefaults.standard.set(enableNotifications, forKey: Keys.enableNotifications)
    }

    // MARK: - Formatted Properties

    var versionString: String {
        "Version \(appVersion) (\(buildNumber))"
    }

    var autoSaveIntervalOptions: [Int] {
        [10, 15, 30, 60]
    }

    func autoSaveIntervalText(_ interval: Int) -> String {
        if interval == 60 {
            return "1 minute"
        } else {
            return "\(interval) seconds"
        }
    }
}
