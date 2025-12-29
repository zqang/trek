# Trek - Setup Guide

This guide will help you set up the Trek project for development.

---

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later
- CocoaPods or Swift Package Manager
- Firebase account (free tier is sufficient for development)
- Apple Developer account (for device testing and App Store submission)

---

## Step 1: Open the Project in Xcode

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/alvin/Developments/llm/202512/trek/Trek
   ```

2. Open the project in Xcode:
   ```bash
   open Trek.xcodeproj
   ```

   **Note**: If the `.xcodeproj` file doesn't exist yet, you'll need to create it through Xcode:
   - Open Xcode
   - File → New → Project
   - Choose "App" template
   - Product Name: "Trek"
   - Team: Your team
   - Organization Identifier: com.yourcompany.trek
   - Interface: SwiftUI
   - Language: Swift
   - Save to the Trek directory

---

## Step 2: Configure Firebase

### 2.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: "Trek" (or your preferred name)
4. Disable Google Analytics (optional for MVP)
5. Click "Create project"

### 2.2 Add iOS App to Firebase

1. In Firebase Console, click the iOS icon to add an iOS app
2. Enter your iOS bundle ID: `com.yourcompany.trek` (must match Xcode)
3. Optional: Enter App nickname: "Trek iOS"
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Drag `GoogleService-Info.plist` into Xcode project (Trek/Trek/Resources/)
   - Make sure "Copy items if needed" is checked
   - Select "Trek" target

### 2.3 Enable Firebase Services

**Authentication:**
1. In Firebase Console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. (Phase 2) Enable "Apple" sign-in method

**Firestore Database:**
1. Go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location (choose closest to your users)
5. Click "Enable"

**Firebase Storage:**
1. Go to "Storage"
2. Click "Get started"
3. Start in test mode
4. Click "Done"

### 2.4 Configure Firestore Security Rules

1. Go to Firestore Database → Rules
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Activities collection
    match /activities/{activityId} {
      allow read: if request.auth != null &&
        (resource.data.userId == request.auth.uid || resource.data.isPrivate == false);
      allow create: if request.auth != null &&
        request.resource.data.userId == request.auth.uid;
      allow update, delete: if request.auth != null &&
        resource.data.userId == request.auth.uid;
    }
  }
}
```

3. Click "Publish"

### 2.5 Configure Storage Security Rules

1. Go to Storage → Rules
2. Replace the rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile photos
    match /profile_photos/{userId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Activity photos (future feature)
    match /activity_photos/{userId}/{activityId}/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Click "Publish"

---

## Step 3: Add Firebase Dependencies

### Option A: Swift Package Manager (Recommended)

1. In Xcode, go to File → Add Package Dependencies
2. Enter Firebase URL: `https://github.com/firebase/firebase-ios-sdk`
3. Select "Up to Next Major Version" with version 10.0.0+
4. Click "Add Package"
5. Select the following products:
   - FirebaseAuth
   - FirebaseFirestore
   - FirebaseFirestoreSwift
   - FirebaseStorage
   - FirebaseAnalytics
   - FirebaseCrashlytics
6. Click "Add Package"

### Option B: CocoaPods

1. Create a `Podfile` in the Trek directory:
   ```ruby
   platform :ios, '16.0'
   use_frameworks!

   target 'Trek' do
     pod 'Firebase/Auth'
     pod 'Firebase/Firestore'
     pod 'Firebase/Storage'
     pod 'Firebase/Analytics'
     pod 'Firebase/Crashlytics'
   end
   ```

2. Install dependencies:
   ```bash
   cd Trek
   pod install
   ```

3. Open the workspace (not the project):
   ```bash
   open Trek.xcworkspace
   ```

---

## Step 4: Configure Project Settings

### 4.1 Set Minimum iOS Version

1. In Xcode, select the Trek project in the navigator
2. Select the Trek target
3. Go to "General" tab
4. Set "Minimum Deployments" to "iOS 16.0"

### 4.2 Configure Signing

1. Select the Trek target
2. Go to "Signing & Capabilities" tab
3. Select your team under "Signing"
4. Xcode will automatically manage signing

### 4.3 Add Capabilities

1. In "Signing & Capabilities" tab, click "+ Capability"
2. Add "Sign in with Apple" (required for Phase 2)

---

## Step 5: Configure Build Settings

### 5.1 Enable SwiftLint (Optional but Recommended)

1. Install SwiftLint via Homebrew:
   ```bash
   brew install swiftlint
   ```

2. In Xcode, select Trek target → Build Phases
3. Click "+" → "New Run Script Phase"
4. Add this script:
   ```bash
   if which swiftlint >/dev/null; then
     swiftlint
   else
     echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
   fi
   ```

---

## Step 6: Test the Setup

### 6.1 Build the Project

1. In Xcode, select a simulator (e.g., iPhone 15 Pro)
2. Press Cmd+B to build
3. Fix any build errors (usually related to missing dependencies)

### 6.2 Run the App

1. Press Cmd+R to run
2. The app should launch with the onboarding screen
3. Try creating an account to test Firebase connection

---

## Step 7: Set Up Git Repository

### 7.1 Initialize Git

```bash
cd /Users/alvin/Developments/llm/202512/trek
git init
```

### 7.2 Create .gitignore

The `.gitignore` file should already exist. If not, create it with:

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

# Firebase
GoogleService-Info.plist

# CocoaPods
Pods/
*.podspec

# Swift Package Manager
.swiftpm/
Package.resolved

# macOS
.DS_Store
```

### 7.3 Make Initial Commit

```bash
git add .
git commit -m "Initial project setup with Firebase integration"
```

### 7.4 Create Branches

```bash
git branch develop
git checkout develop
```

### 7.5 Push to Remote (Optional)

```bash
git remote add origin https://github.com/yourusername/trek.git
git push -u origin main
git push -u origin develop
```

---

## Troubleshooting

### Firebase not connecting
- Ensure `GoogleService-Info.plist` is in the project
- Check that bundle identifier matches Firebase console
- Clean build folder (Cmd+Shift+K) and rebuild

### Build errors
- Check that all Firebase packages are added
- Ensure minimum deployment target is iOS 16.0
- Update Xcode to latest version

### Location permission not working
- Check Info.plist has NSLocationWhenInUseUsageDescription
- Reset simulator location permissions: Device → Erase All Content and Settings

---

## Next Steps

After completing the setup:

1. ✅ Phase 1 complete - Project setup done
2. → Phase 2 - Start implementing Authentication UI (Week 2-3)
3. → Phase 3 - Implement GPS foundation (Week 4)

---

## Resources

- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Core Location Documentation](https://developer.apple.com/documentation/corelocation)
- [Trek Production Plan](../PRODUCTION_PLAN.md)

---

**Last Updated**: December 29, 2025
**Status**: Ready for Development
