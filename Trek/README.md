# Trek iOS App

A Strava-like fitness tracking iOS app built with Swift and SwiftUI.

## Overview

Trek allows users to track their running, cycling, and walking activities with precise GPS tracking, view their activity history, and analyze their performance.

## Features (MVP - v1.0)

- ✅ User authentication (Email/Password + Apple Sign In)
- ✅ Real-time GPS activity tracking with Kalman filtering
- ✅ Activity history with maps and detailed stats
- ✅ Activity splits (pace per km/mi)
- ✅ User profile with aggregate statistics
- ✅ Offline activity recording with automatic sync
- ✅ Dark mode support
- ✅ GPX export and data privacy features

## Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum iOS**: 16.0
- **Architecture**: MVVM (Model-View-ViewModel)
- **Backend**: Firebase (Auth, Firestore, Storage)
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
- Firebase account (free tier)
- Apple Developer account (for device testing)

### Setup

See [SETUP.md](SETUP.md) for detailed setup instructions.

Quick start:

1. Open `Trek.xcodeproj` in Xcode
2. Configure Firebase (see SETUP.md)
3. Add `GoogleService-Info.plist` to the project
4. Select your team in Signing & Capabilities
5. Build and run (Cmd+R)

## Development Timeline

Currently in **Phase 1: Project Setup** ✅

- [x] Phase 1: Project Setup (Week 1)
- [ ] Phase 2: Authentication & Onboarding (Week 2-3)
- [ ] Phase 3: GPS & Location Foundation (Week 4)
- [ ] Phase 4: Activity Recording (Week 5-6)
- [ ] Phase 5: Activity Management (Week 7-8)
- [ ] Phase 6: Profile & Settings (Week 9)
- [ ] Phase 7: Offline Support & Sync (Week 10)
- [ ] Phase 8: Polish & Optimization (Week 11-12)
- [ ] Phase 9: Testing (Week 13-14)
- [ ] Phase 10: App Store Preparation (Week 15-16)
- [ ] Phase 11: Launch & Monitoring (Week 17-18)

## Architecture

### MVVM Pattern

- **Models**: Data structures (User, Activity, etc.)
- **Views**: SwiftUI views
- **ViewModels**: Business logic and state management
- **Services**: API calls, location tracking, etc.

### Key Services

1. **LocationService**: GPS tracking with Kalman filter
2. **AuthService**: Firebase Authentication
3. **FirestoreService**: Database operations
4. **CrashRecoveryService**: Auto-save during recording

## Contributing

This is currently a solo project for educational purposes.

## Privacy

See our [Privacy Policy](https://your-website.com/privacy) for details on how we handle user data.

## License

Copyright © 2025 Trek. All rights reserved.

## Contact

- Email: support@trek-app.com
- Website: https://trek-app.com

---

**Version**: 1.0.0 (MVP)
**Last Updated**: December 29, 2025
**Status**: In Development - Phase 1 Complete
