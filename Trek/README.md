# Trek iOS App

A Strava-like fitness tracking iOS app built with Swift and SwiftUI.

## Overview

Trek allows users to track their running, cycling, and walking activities with precise GPS tracking, view their activity history, and analyze their performance.

## Features (MVP - v1.0)

- User authentication (Email/Password with secure hashing)
- Real-time GPS activity tracking with Kalman filtering
- Activity history with maps and detailed stats
- Activity splits (pace per km/mi)
- User profile with aggregate statistics
- Offline-first design - all data stored locally
- Dark mode support
- GPX export and data privacy features

## Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum iOS**: 16.0
- **Architecture**: MVVM (Model-View-ViewModel)
- **Storage**: Local JSON-based persistence
- **Security**: iOS Keychain for credentials, SHA256 password hashing
- **Location**: Core Location with Kalman filter
- **Maps**: MapKit

## Project Structure

```
Trek/
├── App/                    # App entry point and main navigation
├── Models/                 # Data models
│   ├── User.swift
│   ├── Activity.swift
│   ├── ActivityType.swift
│   └── ...
├── ViewModels/            # Business logic
│   ├── AuthViewModel.swift
│   └── ...
├── Views/                 # UI components
│   ├── Auth/
│   ├── Recording/
│   ├── Activities/
│   ├── Profile/
│   └── Components/
├── Services/              # Service layer
│   ├── AuthService.swift
│   ├── LocationService.swift
│   ├── CoreDataStack.swift
│   └── ...
├── Utilities/             # Utilities and helpers
│   ├── Formatters.swift
│   ├── KalmanFilter.swift
│   └── ...
└── Resources/             # Assets and configuration
    ├── Assets.xcassets
    └── Info.plist
```

## Getting Started

### Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Apple Developer account (for device testing)

### Setup

See [SETUP.md](SETUP.md) for detailed setup instructions.

Quick start:

1. Open `Trek.xcodeproj` in Xcode
2. Select your team in Signing & Capabilities
3. Build and run (Cmd+R)

## Architecture

### MVVM Pattern

- **Models**: Data structures (User, Activity, etc.)
- **Views**: SwiftUI views
- **ViewModels**: Business logic and state management
- **Services**: Location tracking, local storage, etc.

### Key Services

1. **LocationService**: GPS tracking with Kalman filter
2. **AuthService**: Local authentication with Keychain
3. **CoreDataStack**: JSON-based local persistence
4. **CrashRecoveryService**: Auto-save during recording

### Data Storage

All data is stored locally on the device:
- **Users & Activities**: JSON files in Documents/TrekData/
- **Credentials**: iOS Keychain with SHA256 hashed passwords
- **Photos**: Local file storage in Documents directory

## Privacy

Trek is designed with privacy in mind:
- All data stays on your device
- No cloud services or external dependencies
- GDPR compliant with easy data export
- No tracking or analytics

See our [Privacy Policy](../PRIVACY_POLICY.md) for details.

## License

Copyright © 2025 Trek. All rights reserved.

## Contact

- Email: support@trek-app.com
- Website: https://trek-app.com

---

**Version**: 1.0.0 (MVP)
**Last Updated**: December 30, 2025
**Status**: Production Ready - Local Storage Version
