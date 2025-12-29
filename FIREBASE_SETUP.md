# Firebase Setup Guide for Trek

**Created**: December 29, 2025
**Last Updated**: December 29, 2025

## Overview

This guide walks through setting up Firebase for the Trek app, including Authentication, Firestore, Storage, Analytics, and Crashlytics.

## Prerequisites

- [ ] Google/Firebase account
- [ ] iOS app registered in Firebase Console
- [ ] `GoogleService-Info.plist` downloaded and added to Xcode project

## Part 1: Firebase Console Setup

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **Add project** (or select existing project)
3. Enter project name: **Trek** (or your preferred name)
4. Enable Google Analytics: **Yes** (recommended)
5. Choose Analytics account or create new
6. Click **Create project**
7. Wait for project creation (1-2 minutes)

### Step 2: Add iOS App

1. In Firebase Console, click **iOS** icon (⊕)
2. Enter iOS bundle ID: `com.yourcompany.trek` (must match Xcode)
3. Enter app nickname: **Trek iOS**
4. Enter App Store ID: (leave blank for now, add after submission)
5. Click **Register app**

### Step 3: Download Configuration File

1. Download `GoogleService-Info.plist`
2. **IMPORTANT**: Add to `.gitignore` (contains API keys)
3. Drag into Xcode project:
   - Target: Trek
   - Copy items if needed: ✅
   - Add to targets: Trek ✅
4. Verify file is in Xcode navigator under Trek folder

### Step 4: Add Firebase SDK

Already added via Swift Package Manager in Phase 1:
- FirebaseAuth
- FirebaseFirestore
- FirebaseStorage
- FirebaseAnalytics
- FirebaseCrashlytics

**Verify**: Xcode → Project → Package Dependencies → Firebase

---

## Part 2: Authentication Setup

### Enable Authentication Providers

1. Firebase Console → **Authentication**
2. Click **Get started** (if first time)
3. Go to **Sign-in method** tab

### Enable Email/Password

1. Click **Email/Password**
2. Toggle **Enable** to ON
3. Email link (optional): OFF (for now)
4. Click **Save**

### Enable Apple Sign In (Optional but Recommended)

1. Click **Apple**
2. Toggle **Enable** to ON
3. **Services ID**: Leave blank (automatic)
4. **Team ID**: Your Apple Developer Team ID
   - Find at: developer.apple.com → Membership
   - Format: 10 characters (e.g., ABC123DEF4)
5. **Key ID**: Leave blank (or add OAuth key if you have one)
6. Click **Save**

**Note**: Apple Sign In requires additional setup in Apple Developer Portal for production.

---

## Part 3: Firestore Database Setup

### Create Firestore Database

1. Firebase Console → **Firestore Database**
2. Click **Create database**
3. Choose location: **nam5 (us-central)** or your preferred region
   - **Important**: Cannot be changed later
   - Choose region closest to users
4. Security rules: Start in **production mode** (we'll deploy rules next)
5. Click **Enable**
6. Wait for database creation (1-2 minutes)

### Deploy Firestore Indexes

**Method 1: Firebase Console (Manual)**

For each index in `firebase/firestore.indexes.json`:

1. Go to **Firestore Database** → **Indexes** tab
2. Click **Create index**
3. Collection: `activities`
4. Add fields:
   - Field 1: `userId`, Order: Ascending
   - Field 2: `createdAt`, Order: Descending
5. Click **Create**
6. Repeat for other 3 indexes

**Method 2: Firebase CLI (Recommended)**

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in project directory
cd /path/to/trek
firebase init

# Select:
# - Firestore: Configure Firestore security rules and indexes
# - Storage: Configure Firebase Storage security rules
# Choose existing project: Trek
# Firestore rules file: firebase/firestore.rules
# Firestore indexes file: firebase/firestore.indexes.json
# Storage rules file: firebase/storage.rules

# Deploy indexes and rules
firebase deploy --only firestore:indexes
firebase deploy --only firestore:rules
firebase deploy --only storage
```

**Deployment Output**:
```
✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/trek-xxxxx
```

### Verify Indexes

1. Firebase Console → **Firestore Database** → **Indexes**
2. Verify 4 composite indexes exist:
   - `activities`: userId (ASC), createdAt (DESC)
   - `activities`: userId (ASC), distance (DESC)
   - `activities`: userId (ASC), duration (DESC)
   - `activities`: userId (ASC), type (ASC), createdAt (DESC)
3. Status should be **Enabled** (green)

**Note**: Index creation takes 2-5 minutes. Status will show "Building" initially.

### Deploy Security Rules

**Method 1: Firebase Console (Manual)**

1. Firebase Console → **Firestore Database** → **Rules** tab
2. Copy contents from `firebase/firestore.rules`
3. Paste into editor
4. Click **Publish**

**Method 2: Firebase CLI (Already done if you ran deploy above)**

```bash
firebase deploy --only firestore:rules
```

### Test Security Rules

1. Firebase Console → **Firestore Database** → **Rules** tab
2. Click **Rules Playground**
3. Test scenarios:

**Test 1: Unauthenticated read (should fail)**:
```
Location: /users/test_user_123
Authenticated: No
Action: get
Expected: Denied ✅
```

**Test 2: User reads own profile (should succeed)**:
```
Location: /users/test_user_123
Authenticated: Yes
Auth UID: test_user_123
Action: get
Expected: Allowed ✅
```

**Test 3: User reads another's activity (should fail)**:
```
Location: /activities/test_activity
Authenticated: Yes
Auth UID: user_123
Resource data: { userId: "user_456" }
Action: get
Expected: Denied ✅
```

---

## Part 4: Storage Setup

### Enable Firebase Storage

1. Firebase Console → **Storage**
2. Click **Get started**
3. Security rules: Start in **production mode**
4. Choose location: **Same as Firestore** (recommended)
5. Click **Done**

### Deploy Storage Security Rules

**Method 1: Firebase Console**

1. Firebase Console → **Storage** → **Rules** tab
2. Copy contents from `firebase/storage.rules`
3. Paste into editor
4. Click **Publish**

**Method 2: Firebase CLI**

```bash
firebase deploy --only storage
```

### Create Storage Buckets (Automatic)

Buckets are created automatically when first used. For Trek:
- `profile_photos/` - User profile pictures

**Verify**:
1. Upload a test file via app
2. Firebase Console → **Storage** → **Files**
3. Should see `profile_photos/` folder

---

## Part 5: Analytics Setup

### Enable Google Analytics

Analytics should be enabled automatically if you chose it during project creation.

**Verify**:
1. Firebase Console → **Analytics** → **Dashboard**
2. Should see "Waiting for data" (data appears after app usage)

### Configure Analytics Events

Custom events are already implemented in code:

```swift
// Example events in Trek
Analytics.logEvent("activity_recorded", parameters: [
    "activity_type": activityType.rawValue,
    "distance": distance,
    "duration": duration
])

Analytics.logEvent("activity_saved", parameters: [
    "activity_id": activityId
])
```

**View Events**:
1. Firebase Console → **Analytics** → **Events**
2. Events appear 24-48 hours after first usage
3. Common events:
   - `first_open`
   - `session_start`
   - Custom: `activity_recorded`, `activity_saved`

### Configure User Properties

```swift
// Set user properties
Analytics.setUserProperty("preferred_unit", value: "metric")
Analytics.setUserProperty("activity_type", value: "run")
```

**View Properties**:
Firebase Console → **Analytics** → **User Properties**

---

## Part 6: Crashlytics Setup

### Enable Crashlytics

1. Firebase Console → **Crashlytics**
2. Click **Get started** (if first time)
3. Follow setup instructions (SDK already added)

### Verify Crashlytics Integration

**In Xcode**:

1. Build and run Trek on simulator or device
2. Force a test crash (optional):

```swift
// Add to TrekApp.swift (REMOVE BEFORE PRODUCTION)
#if DEBUG
Button("Test Crash") {
    fatalError("Test crash for Crashlytics")
}
#endif
```

3. Restart app (crash reports sent on next launch)
4. Check Firebase Console → **Crashlytics** in 5-10 minutes

### Configure Crashlytics

Already configured in `TrekApp.swift`:

```swift
import FirebaseCrashlytics

init() {
    FirebaseApp.configure()

    #if DEBUG
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    #endif
}
```

**Custom Logs**:
```swift
// Log custom events
Crashlytics.crashlytics().log("User started activity recording")

// Set user identifier
Crashlytics.crashlytics().setUserID(userId)

// Custom keys for debugging
Crashlytics.crashlytics().setCustomValue(activityType, forKey: "activity_type")
```

---

## Part 7: Environment Configuration

### Development vs. Production

**Option 1: Single Firebase Project (Simpler)**

Use one Firebase project for both development and production:
- Easier to manage
- Shared data (be careful!)
- Recommended for solo developers

**Option 2: Separate Firebase Projects (Recommended for Teams)**

Create two Firebase projects:
1. **Trek Dev** - For development and testing
2. **Trek Prod** - For production App Store release

**Setup**:
```
Trek/
├── Development/
│   └── GoogleService-Info.plist (Dev project)
└── Production/
    └── GoogleService-Info.plist (Prod project)
```

**Xcode Configuration**:
1. Create separate build configurations (Debug, Release)
2. Use different `GoogleService-Info.plist` for each
3. Build Schemes → Trek → Run → Build Configuration → Debug (uses Dev)
4. Build Schemes → Trek → Archive → Build Configuration → Release (uses Prod)

---

## Part 8: Offline Persistence

### Enable Offline Persistence

Already enabled in `TrekApp.swift`:

```swift
let settings = FirestoreSettings()
settings.isPersistenceEnabled = true
Firestore.firestore().settings = settings
```

**Verify**:
1. Run app with internet
2. Create some activities
3. Enable Airplane Mode
4. Restart app
5. Activities should still be visible ✅

### Offline Persistence Limits

- **Cache Size**: Default 100 MB
- **Can increase**:
```swift
settings.cacheSizeBytes = 200 * 1024 * 1024 // 200 MB
```

---

## Part 9: Testing & Verification

### Complete Firebase Checklist

**Authentication**:
- [ ] Email/Password provider enabled
- [ ] Apple Sign In configured (optional)
- [ ] Sign up works in app
- [ ] Login works in app
- [ ] Users appear in Firebase Console → Authentication

**Firestore**:
- [ ] Database created
- [ ] 4 composite indexes deployed and enabled
- [ ] Security rules deployed
- [ ] Offline persistence enabled
- [ ] Activities save to Firestore
- [ ] Security rules tested (users can't read others' data)

**Storage**:
- [ ] Storage enabled
- [ ] Security rules deployed
- [ ] Profile photo upload works
- [ ] Files appear in Firebase Console → Storage

**Analytics**:
- [ ] Analytics enabled
- [ ] Events logging (check code)
- [ ] User properties set

**Crashlytics**:
- [ ] Crashlytics enabled
- [ ] Test crash sent (optional)
- [ ] Crash appears in console

### Test Scenarios

**Test 1: Complete Flow (With Internet)**
1. Sign up new user
2. Record activity (walk for 2 minutes)
3. Save activity
4. Verify in Firestore Console
5. Edit activity name
6. Delete activity
7. Delete account
8. Verify user and activities deleted from Firestore

**Test 2: Offline Flow**
1. Sign in with existing user
2. Enable Airplane Mode
3. Record activity
4. Save activity (should save locally)
5. Disable Airplane Mode
6. Wait 10 seconds
7. Verify activity synced to Firestore ✅

**Test 3: Security (Via Console)**
1. Try to read another user's activity
2. Should be denied ✅

---

## Part 10: Monitoring & Maintenance

### Firebase Console Dashboard

Regular monitoring:

1. **Authentication** → Users
   - Track user growth
   - Monitor sign-in methods

2. **Firestore** → Usage
   - Document reads/writes
   - Storage usage
   - Ensure within free tier limits

3. **Storage** → Usage
   - Files and bandwidth
   - Delete unused files

4. **Analytics** → Dashboard
   - Active users (DAU, MAU)
   - User engagement
   - Event funnels

5. **Crashlytics** → Dashboard
   - Crash-free rate (target: >99%)
   - Top crashes
   - Affected users

### Firebase Free Tier Limits

**Firestore**:
- 50K reads/day
- 20K writes/day
- 1 GB storage
- 10 GB/month bandwidth

**Storage**:
- 5 GB storage
- 1 GB/day downloads

**Authentication**:
- Unlimited (phone auth has limits)

**Analytics & Crashlytics**:
- Unlimited

**Monitoring Usage**:
Firebase Console → Settings → Usage and billing

**Upgrade if needed**:
- Blaze plan (pay-as-you-go)
- Only pay for what you use beyond free tier

---

## Part 11: Security Best Practices

### API Keys

**GoogleService-Info.plist**:
- ✅ Add to `.gitignore`
- ❌ Never commit to public repos
- ✅ Restrict API keys in Google Cloud Console (production)

### Security Rules

**Review regularly**:
- Rules are your backend security
- Test with Rules Playground
- Update as features evolve

**Common mistakes**:
- ❌ `allow read, write: if true;` (never do this!)
- ❌ Forgetting to check `request.auth.uid`
- ✅ Always validate userId matches auth user

### Data Validation

Add validation to security rules:

```javascript
// Validate activity data
allow create: if isAuthenticated() &&
                 isOwner(request.resource.data.userId) &&
                 request.resource.data.distance >= 0 &&
                 request.resource.data.duration >= 0 &&
                 request.resource.data.type in ['run', 'ride', 'walk', 'hike'];
```

---

## Troubleshooting

### Common Issues

**Issue**: "FirebaseApp not configured"
- **Solution**: Ensure `FirebaseApp.configure()` is called in `TrekApp.init()`
- **Solution**: Verify `GoogleService-Info.plist` is in Xcode project

**Issue**: "Permission denied" in Firestore
- **Solution**: Check security rules are deployed
- **Solution**: Verify user is authenticated
- **Solution**: Check userId matches auth.uid

**Issue**: "Index not ready"
- **Solution**: Wait 2-5 minutes for index to build
- **Solution**: Check Firebase Console → Indexes status

**Issue**: Offline persistence not working
- **Solution**: Verify `isPersistenceEnabled = true`
- **Solution**: Check cache size limits
- **Solution**: Clear app data and retry

**Issue**: Analytics not showing data
- **Solution**: Wait 24-48 hours for data to appear
- **Solution**: Verify Analytics is enabled in Firebase project
- **Solution**: Check app is logging events

---

## Quick Start Commands

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize project
cd /path/to/trek
firebase init

# Deploy all
firebase deploy

# Deploy specific services
firebase deploy --only firestore:indexes
firebase deploy --only firestore:rules
firebase deploy --only storage

# View logs
firebase functions:log

# Open Firebase Console
firebase open
```

---

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Security Rules Guide](https://firebase.google.com/docs/rules)
- [Firebase Console](https://console.firebase.google.com)

---

## Summary Checklist

Before App Store submission:

**Critical**:
- [ ] Firebase project created
- [ ] iOS app registered in Firebase
- [ ] `GoogleService-Info.plist` added to Xcode (not committed to git)
- [ ] Authentication providers enabled (Email/Password, Apple Sign In)
- [ ] Firestore database created
- [ ] 4 composite indexes deployed and enabled
- [ ] Firestore security rules deployed
- [ ] Storage enabled and rules deployed
- [ ] Analytics enabled
- [ ] Crashlytics enabled
- [ ] Test complete user flow (sign up → record → save)
- [ ] Test offline functionality
- [ ] Verify security (users can't access others' data)

**Optional (But Recommended)**:
- [ ] Separate Dev/Prod Firebase projects
- [ ] API key restrictions in Google Cloud Console
- [ ] Budget alerts configured
- [ ] Team members added with appropriate roles

---

**Firebase is the backbone of Trek. Take time to configure it properly!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Setup Time**: 30-60 minutes
