# Trek - Setup Guide

This guide will help you set up the Trek project for development.

---

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Apple Developer account (for device testing and App Store submission)

---

## Step 1: Open the Project in Xcode

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /path/to/trek/Trek
   ```

2. Open the project in Xcode:
   ```bash
   open Trek.xcodeproj
   ```

---

## Step 2: Storage Architecture

Trek uses **local-only storage** for privacy and cost-effectiveness:

- **Core Data**: All user data and activities are stored locally on the device
- **Keychain**: Secure password storage using iOS Keychain
- **Local File Storage**: Profile photos and activity photos stored in app's Documents directory

**Benefits:**
- No cloud costs or Firebase billing
- Complete data privacy - all data stays on device
- Works offline - no internet required
- GDPR compliant - easy data export and deletion

---

## Step 3: Configure Project Settings

### 3.1 Set Minimum iOS Version

1. In Xcode, select the Trek project in the navigator
2. Select the Trek target
3. Go to "General" tab
4. Set "Minimum Deployments" to "iOS 16.0"

### 3.2 Configure Signing

1. Select the Trek target
2. Go to "Signing & Capabilities" tab
3. Select your team under "Signing"
4. Xcode will automatically manage signing

---

## Step 4: Test the Setup

### 4.1 Build the Project

1. In Xcode, select a simulator (e.g., iPhone 15 Pro)
2. Press Cmd+B to build
3. Fix any build errors

### 4.2 Run the App

1. Press Cmd+R to run
2. The app should launch with the onboarding screen
3. Create an account to test local authentication

---

## Step 5: Data Persistence

### Core Data Model

The app uses Core Data with two main entities:

**UserEntity:**
- id (UUID)
- email (String)
- name (String)
- bio (String?)
- profilePhotoPath (String?)
- totalDistance (Double)
- totalActivities (Int32)
- totalDuration (Double)
- preferredUnits (String)
- createdAt (Date)

**ActivityEntity:**
- id (UUID)
- userId (UUID)
- name (String?)
- type (String)
- startTime (Date)
- endTime (Date?)
- distance (Double)
- duration (Double)
- elevationGain (Double)
- routeData (Binary) - encoded [LocationPoint] array
- calories (Double)

### File Storage

Photos are stored locally in the app's Documents directory:
- `/Documents/profile_photos/{userId}/{filename}.jpg`
- `/Documents/activity_photos/{userId}/{activityId}/{filename}.jpg`

---

## Step 6: Set Up Git Repository (Optional)

### 6.1 Initialize Git

```bash
cd /path/to/trek
git init
```

### 6.2 Create .gitignore

```
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcworkspace/contents.xcworkspacedata
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
DerivedData/
.build/
*.moved-aside
*.pbxuser
!default.pbxuser
*.mode1v3
!default.mode1v3
*.mode2v3
!default.mode2v3
*.perspectivev3
!default.perspectivev3
xcuserdata/

# Swift Package Manager
.swiftpm/
Package.resolved

# macOS
.DS_Store
```

### 6.3 Make Initial Commit

```bash
git add .
git commit -m "Initial project setup with local Core Data storage"
```

---

## Troubleshooting

### Build errors
- Ensure minimum deployment target is iOS 16.0
- Update Xcode to latest version
- Clean build folder (Cmd+Shift+K) and rebuild

### Location permission not working
- Check Info.plist has NSLocationWhenInUseUsageDescription
- Reset simulator location permissions: Device → Erase All Content and Settings

### Core Data issues
- If schema changes, delete the app from simulator and rebuild
- Check that Trek.xcdatamodeld is included in the project

---

## Data Export

Trek supports GDPR-compliant data export:

1. Go to Profile → Settings → Export Data
2. All activities are exported as GPX files
3. Files can be shared or saved to Files app

---

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Data Documentation](https://developer.apple.com/documentation/coredata)
- [Core Location Documentation](https://developer.apple.com/documentation/corelocation)

---

**Last Updated**: December 30, 2025
**Status**: Ready for Development (Local Storage Version)
