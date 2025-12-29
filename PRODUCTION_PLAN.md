# Trek - Production Plan (MVP First Release)

## Executive Summary
Trek is a Strava-like fitness tracking iOS app built with Swift. This plan focuses on delivering a minimum viable product (MVP) with core features essential for fitness tracking, then scaling to production.

---

## 1. MVP Core Features (First Release)

### 1.1 Essential Features
1. **User Authentication**
   - Email/password registration and login
   - Apple Sign In (required for App Store)
   - Password reset functionality
   - Basic profile setup
   - **Onboarding flow** with permission explanations

2. **Activity Recording** (Foreground Tracking for MVP)
   - Real-time GPS tracking for running, cycling, and walking
   - Live stats during activity (distance, duration, pace, speed, elevation)
   - Pause/resume functionality
   - Save and discard activities
   - **Auto-save every 30 seconds** for crash recovery
   - **GPS smoothing** for accurate tracking (Kalman filter)
   - **Activity splits** (pace/speed per km or mile)
   - Activity type detection and manual selection
   - Note: Background tracking deferred to v1.1 to reduce complexity

3. **Activity Details & History**
   - List of completed activities with pagination
   - Detailed activity view with:
     - Map route visualization with optimized rendering
     - Comprehensive stats (distance, time, pace/speed, elevation gain)
     - **Activity splits** (pace per km/mi)
     - Date and time
     - Activity type (run, ride, walk, hike)
   - Edit activity name and type
   - Delete activities
   - **Export activities** (GPX format)
   - Empty states for new users

4. **User Profile & Settings**
   - Profile photo upload
   - Aggregate stats (total distance, total activities, total time)
   - Settings:
     - Unit preferences (km/mi, metric/imperial)
     - **Privacy controls** (activity visibility)
     - **Dark mode support** (automatic)
   - **Data privacy features**:
     - Export all my data (GPX files)
     - Delete account and all data
   - Logout functionality

5. **Offline Support**
   - Record activities without internet connection
   - Automatic sync when connection is restored
   - Sync status indicators
   - Conflict resolution for offline changes

6. **UI/UX Essentials**
   - **Dark mode support** (follows system settings)
   - Accessibility support (VoiceOver, Dynamic Type)
   - Loading states and error handling
   - Empty states with helpful guidance

---

## 2. Technology Stack

### 2.1 iOS Development
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI (modern, declarative UI)
- **Minimum iOS Version**: iOS 16.0
- **Architecture**: MVVM (Model-View-ViewModel)

### 2.2 Core iOS Frameworks
- **Core Location**: GPS tracking and location services
- **MapKit**: Map visualization and route rendering
- **Combine**: Reactive programming for data flow
- **HealthKit**: (Optional v1.1) Integration with Apple Health for heart rate

### 2.3 Backend & Services
- **Backend**: Firebase (recommended for MVP)
  - **Authentication**: Firebase Auth with email/password and Apple Sign In
  - **Database**: Firestore with **offline persistence enabled** (replaces Core Data)
  - **Storage**: Firebase Storage for profile photos
  - **Cloud Functions**: Server-side logic (delete user data, etc.)
  - **Analytics**: Firebase Analytics for user behavior tracking
  - **Crashlytics**: Crash reporting and monitoring
- **Note**: Firestore offline persistence handles local caching, eliminating need for Core Data
- **Alternative**: AWS Amplify or custom backend (Node.js/PostgreSQL) for future scaling

### 2.4 Dependencies (via Swift Package Manager)
- Firebase SDK
- Kingfisher (image loading/caching)
- SwiftLint (code quality)

### 2.5 Development Tools
- Xcode 15+
- Git for version control
- TestFlight for beta testing
- Fastlane for CI/CD automation

---

## 3. Technical Architecture

### 3.1 App Architecture
```
Trek/
├── App/
│   ├── TrekApp.swift (App entry point)
│   └── AppDelegate.swift (for remote notifications if needed)
├── Models/
│   ├── User.swift
│   ├── Activity.swift
│   ├── ActivityType.swift (enum: run, ride, walk, hike)
│   ├── LocationPoint.swift
│   ├── ActivityStats.swift
│   └── Split.swift (pace/speed per km/mi)
├── ViewModels/
│   ├── AuthViewModel.swift
│   ├── RecordingViewModel.swift
│   ├── ActivityListViewModel.swift
│   ├── ActivityDetailViewModel.swift
│   ├── ProfileViewModel.swift
│   └── OnboardingViewModel.swift
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   ├── SignUpView.swift
│   │   └── OnboardingView.swift
│   ├── Recording/
│   │   ├── RecordingView.swift
│   │   ├── ActivitySummaryView.swift
│   │   ├── LiveStatsView.swift
│   │   └── SplitsView.swift
│   ├── Activities/
│   │   ├── ActivityListView.swift
│   │   ├── ActivityDetailView.swift
│   │   └── EmptyActivitiesView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── SettingsView.swift
│   │   ├── PrivacySettingsView.swift
│   │   └── DataExportView.swift
│   └── Components/
│       ├── MapView.swift
│       ├── RouteMapView.swift
│       ├── StatsCard.swift
│       ├── ActivityRow.swift
│       ├── SplitRow.swift
│       └── LoadingView.swift
├── Services/
│   ├── LocationService.swift (GPS tracking, Kalman filter)
│   ├── ActivityService.swift (CRUD, GPX export)
│   ├── AuthService.swift (Firebase Auth)
│   ├── FirestoreService.swift (database operations)
│   ├── StorageService.swift (profile photos)
│   └── CrashRecoveryService.swift (auto-save, recovery)
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions.swift
│   ├── Formatters.swift (distance, pace, time)
│   ├── UnitConverter.swift (km/mi conversions)
│   ├── KalmanFilter.swift (GPS smoothing)
│   └── GPXExporter.swift (activity export)
└── Resources/
    ├── Assets.xcassets
    ├── Info.plist
    └── GoogleService-Info.plist (Firebase config)
```

### 3.2 Data Models
```swift
// Core data models (Firestore documents)
struct User {
    let id: String
    let email: String
    var name: String
    var profilePhotoURL: String?
    var totalDistance: Double  // meters
    var totalActivities: Int
    var totalDuration: TimeInterval  // seconds
    var preferredUnits: UnitSystem  // metric/imperial
}

enum ActivityType: String, Codable {
    case run, ride, walk, hike

    var displayName: String { ... }
    var icon: String { ... }
    var primaryMetric: MetricType {
        switch self {
        case .run, .walk, .hike: return .pace  // min/km
        case .ride: return .speed  // km/h
        }
    }
}

struct Activity {
    let id: String
    let userId: String
    var name: String
    var type: ActivityType
    let startTime: Date
    let endTime: Date
    let distance: Double  // meters
    let duration: TimeInterval  // seconds (excluding pauses)
    let elevationGain: Double  // meters
    let route: [LocationPoint]  // GPS coordinates
    let splits: [Split]  // pace per km/mi
    var isPrivate: Bool
}

struct LocationPoint: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let timestamp: Date
    let speed: Double  // m/s
    let horizontalAccuracy: Double
}

struct Split {
    let index: Int  // 1st km, 2nd km, etc.
    let distance: Double  // 1000m or 1609m
    let duration: TimeInterval
    let pace: Double  // seconds per km/mi
}

struct ActivityStats {
    let distance: Double
    let duration: TimeInterval
    let pace: Double  // avg seconds per km
    let speed: Double  // avg km/h
    let elevationGain: Double
    let splits: [Split]
}
```

### 3.3 Key Services
1. **LocationService**:
   - Manages Core Location (CLLocationManager)
   - Implements Kalman filter for GPS smoothing
   - Calculates real-time stats (distance, pace, speed)
   - Handles signal loss and recovery
   - Detects movement/stationary states

2. **ActivityService**:
   - CRUD operations for activities
   - Syncs with Firestore
   - Calculates elevation gain (using elevation API if needed)
   - Generates splits (per km/mi)
   - Exports activities to GPX format

3. **AuthService**:
   - Firebase Authentication integration
   - Email/password and Apple Sign In
   - Session management
   - User profile operations

4. **FirestoreService**:
   - Database operations with offline persistence
   - Handles network connectivity changes
   - Implements retry logic with exponential backoff
   - Manages pagination for activity lists

5. **CrashRecoveryService**:
   - Auto-saves recording state every 30 seconds
   - Detects interrupted recordings on app launch
   - Provides recovery UI for incomplete activities
   - Stores state in UserDefaults for quick access

---

## 4. Development Phases

### Phase 1: Project Setup (Week 1)
- [ ] Create Xcode project with SwiftUI + iOS 16 minimum
- [ ] Set up Git repository and branching strategy (main, develop, feature/*)
- [ ] Configure Firebase project and integrate SDK
- [ ] Enable Firestore offline persistence
- [ ] Set up CI/CD pipeline (GitHub Actions + Fastlane)
- [ ] Configure code signing and provisioning profiles
- [ ] Set up project structure and architecture (MVVM)
- [ ] Configure SwiftLint and coding standards
- [ ] Set up Firestore data models and security rules
- [ ] Configure Info.plist with required permission strings

### Phase 2: Authentication & Onboarding (Week 2-3)
- [ ] Implement Firebase Authentication service
- [ ] Build onboarding flow with permission explanations
- [ ] Design and implement login/signup UI
- [ ] Implement Apple Sign In integration
- [ ] Add email/password authentication
- [ ] Add password reset functionality
- [ ] Implement session management
- [ ] Add user profile creation with Firestore
- [ ] Build initial profile setup (name, photo)
- [ ] Add dark mode color scheme

### Phase 3: GPS & Location Foundation (Week 4)
- [ ] Implement LocationService with Core Location
- [ ] Request "When In Use" location permission
- [ ] Implement Kalman filter for GPS smoothing
- [ ] Add distance calculation using Haversine formula
- [ ] Implement speed and pace calculations with smoothing
- [ ] Add movement detection (stationary vs moving)
- [ ] Handle GPS signal loss and recovery
- [ ] Test GPS accuracy in various conditions
- [ ] Implement location permission edge cases

### Phase 4: Activity Recording (Week 5-6)
- [ ] Build recording UI with live stats display
- [ ] Implement start/pause/resume/stop controls
- [ ] Add real-time stat updates (distance, pace, speed, time)
- [ ] Implement auto-save every 30 seconds (CrashRecoveryService)
- [ ] Calculate splits (pace per km/mi) during recording
- [ ] Show live route on map during recording
- [ ] Add activity type selection (run, ride, walk, hike)
- [ ] Implement activity save to Firestore
- [ ] Add activity discard confirmation
- [ ] Build activity summary screen after save
- [ ] Add haptic feedback for pause/resume
- [ ] Test battery consumption during recording

### Phase 5: Activity Management (Week 7-8)
- [ ] Build activity list view with pagination
- [ ] Implement activity detail view
- [ ] Add map route rendering with optimized polyline
- [ ] Display comprehensive stats (distance, time, pace, elevation)
- [ ] Show activity splits in detail view
- [ ] Implement edit activity (name, type)
- [ ] Add delete activity with confirmation
- [ ] Implement pull-to-refresh
- [ ] Add empty state for new users
- [ ] Implement GPX export functionality
- [ ] Add share activity (GPX file)
- [ ] Optimize map rendering for long routes (simplification)

### Phase 6: Profile & Settings (Week 9)
- [ ] Build user profile view
- [ ] Display aggregate stats (total distance, activities, time)
- [ ] Implement profile photo upload to Firebase Storage
- [ ] Create settings screen
- [ ] Add unit preferences (metric/imperial)
- [ ] Add privacy settings (activity visibility)
- [ ] Implement "Export All Data" feature (all activities as GPX)
- [ ] Implement "Delete Account" with data removal
- [ ] Add data deletion Cloud Function
- [ ] Implement logout functionality
- [ ] Add account settings (change email, password)

### Phase 7: Offline Support & Sync (Week 10)
- [ ] Configure Firestore offline persistence
- [ ] Test offline activity recording
- [ ] Handle network connectivity changes
- [ ] Add sync status indicators
- [ ] Test conflict resolution scenarios
- [ ] Add retry logic for failed uploads
- [ ] Implement queue for pending uploads
- [ ] Test airplane mode scenarios
- [ ] Add manual sync trigger

### Phase 8: Polish & Optimization (Week 11-12)
- [ ] UI/UX refinements and consistency
- [ ] Dark mode testing and adjustments
- [ ] Performance optimization (profile with Instruments)
- [ ] Battery usage optimization
- [ ] Memory leak detection and fixes
- [ ] Accessibility improvements (VoiceOver, Dynamic Type)
- [ ] Error handling and user-friendly messages
- [ ] Loading states and skeleton screens
- [ ] Add empty states across all screens
- [ ] Smooth animations and transitions
- [ ] Test on various device sizes (SE, Pro, Pro Max)

### Phase 9: Comprehensive Testing (Week 13-14)
**Automated Testing:**
- [ ] Unit tests for ViewModels (60%+ coverage)
- [ ] Unit tests for Services (LocationService, ActivityService)
- [ ] Unit tests for Utilities (Kalman filter, formatters)
- [ ] UI tests for authentication flow
- [ ] UI tests for recording flow
- [ ] UI tests for activity viewing flow
- [ ] Integration tests for Firestore sync

**GPS-Specific Testing:**
- [ ] Test GPS accuracy on 10+ known distance routes (±2% target)
- [ ] Test in urban environments (tall buildings, GPS interference)
- [ ] Test in forests/areas with tree cover
- [ ] Test in tunnels and underpasses (signal loss)
- [ ] Test high-speed cycling (>30 km/h)
- [ ] Test stationary detection (no GPS drift recording)
- [ ] Measure battery drain (target: <10% per hour of recording)
- [ ] Test app termination and crash recovery

**Manual Testing:**
- [ ] Test on iPhone 12, 13, 14, 15 (various sizes)
- [ ] Test on iOS 16, 17, 18
- [ ] Test all edge cases (low storage, no network, etc.)
- [ ] Test accessibility features
- [ ] Test with real outdoor activities (5-10 runs/rides)

**Beta Testing:**
- [ ] Internal testing (1 week, 3-5 testers)
- [ ] External TestFlight beta (2-3 weeks, 20-50 testers)
- [ ] Collect and address feedback
- [ ] Fix critical bugs from beta testing

### Phase 10: App Store Preparation (Week 15-16)
- [ ] Design app icon (1024x1024)
- [ ] Create screenshots for all required sizes
- [ ] Record app preview video (optional but recommended)
- [ ] Write compelling app description
- [ ] Research and add keywords for ASO
- [ ] Prepare privacy policy (publish on website)
- [ ] Create support URL and contact email
- [ ] Set up App Store Connect listing
- [ ] Fill out App Privacy details
- [ ] Configure pricing (free for MVP)
- [ ] Submit build for App Review
- [ ] Address review feedback if needed (expect 1-2 iterations)

### Phase 11: Launch & Monitoring (Week 17-18)
- [ ] Production release to App Store
- [ ] Verify Firebase Analytics tracking
- [ ] Verify Crashlytics integration
- [ ] Monitor crash rate (target: <2%)
- [ ] Monitor user reviews and respond
- [ ] Monitor backend performance and costs
- [ ] Create user documentation / FAQ
- [ ] Prepare support email templates
- [ ] Plan version 1.1 features based on feedback
- [ ] Monitor first-week metrics (downloads, DAU, retention)

---

## 5. Critical Implementation Details

### 5.1 GPS Tracking Implementation

**Location Manager Configuration:**
```swift
// LocationService.swift
let locationManager = CLLocationManager()
locationManager.desiredAccuracy = kCLLocationAccuracyBest
locationManager.distanceFilter = 10  // meters
locationManager.activityType = .fitness
locationManager.pausesLocationUpdatesAutomatically = false
```

**GPS Smoothing with Kalman Filter:**
- Raw GPS data is noisy and inaccurate
- Implement simple Kalman filter to smooth coordinates
- Average speed calculations over 10-20 second windows
- Filter out GPS points with low horizontal accuracy (>50m)
- Ignore stationary GPS drift (speed <0.5 m/s for >10 seconds)

**Handling Signal Loss:**
- Detect GPS signal loss (no updates for >30 seconds)
- Show indicator to user: "GPS signal lost"
- Continue timer but mark route segment as interpolated
- Resume tracking when signal returns
- Don't count stationary drift while signal is weak

**Elevation Handling:**
- GPS altitude is inaccurate (±50-100m error)
- Option 1: Use GPS altitude with heavy smoothing
- Option 2: Use elevation API (Google, Mapbox) to get accurate data
- Calculate elevation gain: sum only positive elevation changes >3m

**Distance Calculation:**
```swift
// Use Haversine formula for accuracy
func distance(from: CLLocation, to: CLLocation) -> Double {
    return from.distance(from: to)  // Core Location handles this
}
```

**Splits Calculation:**
- Track cumulative distance during recording
- When distance crosses km/mi threshold, calculate split
- Split pace = time elapsed since last split / distance
- Store splits array with activity

### 5.2 Battery Optimization

**Location Settings:**
- Use `kCLLocationAccuracyBest` only during active recording
- Update every 10 meters (distanceFilter) to reduce CPU usage
- Set appropriate `activityType` (.fitness or .otherNavigation)
- For MVP: Require screen to stay on (foreground only)
- Target: <10% battery drain per hour of recording

**Background Tracking (v1.1):**
- Requires "Always Allow" permission (users are hesitant)
- Use background location updates mode
- Must handle app termination by system
- Complex state management required
- **Recommendation: Defer to v1.1 after MVP validation**

**Sync Optimization:**
- Batch uploads when on WiFi
- Compress route data before uploading
- Use Firestore offline persistence to minimize reads
- Implement exponential backoff for retries

**Performance Monitoring:**
- Profile with Instruments regularly
- Monitor Energy Log in Xcode
- Test battery drain with actual outdoor activities
- Identify and fix memory leaks early

### 5.3 Data Privacy & GDPR Compliance

**Privacy Policy Requirements:**
- Explain why location data is collected (activity tracking)
- Describe how data is stored (Firebase, encrypted)
- Explain data retention policy (kept indefinitely unless deleted)
- List third-party services (Firebase, Analytics)
- Provide contact for privacy questions

**GDPR Features (EU Users):**
- Cookie/tracking consent banner (for Firebase Analytics)
- Right to access data → "Export All Data" button
- Right to deletion → "Delete Account" button
- Right to portability → GPX export format
- Data processing agreement with Firebase

**Security Best Practices:**
- Store auth tokens in Keychain (not UserDefaults)
- Use Firebase Security Rules to protect user data
- Validate all user inputs
- Use HTTPS only (Firebase enforces this)
- Don't log sensitive user data

**Firebase Security Rules Example:**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /activities/{activityId} {
      allow read, write: if request.auth != null
        && resource.data.userId == request.auth.uid;
    }
  }
}
```

### 5.4 Crash Recovery System

**Auto-Save Mechanism:**
```swift
// Save recording state every 30 seconds
struct RecordingState: Codable {
    let activityId: String
    let startTime: Date
    let route: [LocationPoint]
    let isPaused: Bool
    let pausedDuration: TimeInterval
}

// Store in UserDefaults for fast access
UserDefaults.standard.set(encodedState, forKey: "pendingRecording")
```

**Recovery Flow:**
```swift
// On app launch
if let pendingRecording = loadPendingRecording() {
    // Show alert: "You have an incomplete activity. Resume or discard?"
    // Resume: Restore LocationService state and continue
    // Discard: Delete pending state
}
```

### 5.5 User Experience Guidelines

**Onboarding Flow:**
1. Welcome screen explaining app purpose
2. Request location permission with clear explanation
3. Quick tutorial: "How to record your first activity"
4. Optional: Request notification permission (for future features)

**Activity Recording UX:**
- Large, accessible start/pause/stop buttons
- Live stats always visible (distance, pace, time)
- Audio cues for km/mi splits (optional)
- Haptic feedback on pause/resume
- Show GPS signal strength indicator
- Battery level warning if <20%

**Empty States:**
- No activities yet: "Record your first activity!"
- No internet: "Recording available offline"
- GPS not available: "Location services required"
- Account deletion: "Are you sure? This cannot be undone."

**Error Handling:**
- Location permission denied → Show settings deeplink
- Upload failed → Show retry button
- GPS signal lost → Visual indicator, continue recording
- Low storage → Warning before recording
- Account deletion failed → Contact support

### 5.6 Activity Type Detection

**Simple Heuristic:**
```swift
func detectActivityType(avgSpeed: Double) -> ActivityType {
    // Speed in m/s
    if avgSpeed < 2.5 {
        return .walk  // <9 km/h
    } else if avgSpeed < 5.0 {
        return .run   // <18 km/h
    } else {
        return .ride  // >18 km/h
    }
}
```

**User Override:**
- Allow manual selection before starting
- Allow changing type after completing activity
- Remember last used activity type

**Metrics by Type:**
```swift
extension ActivityType {
    var primaryMetric: String {
        switch self {
        case .run, .walk, .hike:
            return "Pace"  // min/km or min/mi
        case .ride:
            return "Speed"  // km/h or mph
        }
    }

    var icon: String {
        switch self {
        case .run: return "figure.run"
        case .ride: return "bicycle"
        case .walk: return "figure.walk"
        case .hike: return "figure.hiking"
        }
    }
}
```

---

## 6. Testing Strategy

### 6.1 Automated Testing
- **Unit Tests**: 60%+ code coverage for business logic
  - ViewModels
  - Services
  - Utilities
- **UI Tests**: Critical user flows
  - Login/signup flow
  - Activity recording flow
  - Activity viewing flow
- **Integration Tests**: Service interactions

### 6.2 Manual Testing
- Test on real devices (iPhone 12+)
- Test in real-world conditions (outdoor runs/rides)
- Test various network conditions
- Test with different iOS versions
- Test accessibility features

### 6.3 Beta Testing
- Internal testing with team (1 week)
- External beta via TestFlight (2 weeks)
- Collect feedback and iterate
- Target: 20-50 beta testers

---

## 7. App Store Requirements

### 7.1 Mandatory Requirements
- [ ] Privacy Policy URL
- [ ] Support URL
- [ ] App Store description and keywords
- [ ] Screenshots (6.7", 6.5", 5.5" displays)
- [ ] App icon (1024x1024)
- [ ] Apple Sign In (if using social auth)
- [ ] Location usage descriptions in Info.plist
- [ ] Background modes configuration

### 7.2 Info.plist Keys Required
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Trek needs your location to track your running and cycling activities</string>

<!-- Only if implementing background tracking in v1.1 -->
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Trek needs background location access to record activities while the app is in the background</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Trek needs access to your photo library to set your profile picture</string>

<!-- Only if implementing background tracking -->
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
```

### 7.3 App Privacy Details (App Store Connect)
Must declare all data collected:
- **Location**: Used for activity tracking, linked to user
- **Email Address**: For authentication, linked to user
- **Name**: User profile, linked to user
- **Photos**: Profile picture (optional), linked to user
- **User ID**: Account management, linked to user
- **Product Interaction**: Analytics, not linked to user
- **Crash Data**: Diagnostics, not linked to user

---

## 8. Production Checklist

### 8.1 Pre-Launch
- [ ] All critical features tested and working
- [ ] Analytics and crash reporting configured
- [ ] Privacy policy and terms of service published
- [ ] App Store listing completed
- [ ] Support email/website set up
- [ ] Backend infrastructure scaled for launch
- [ ] Database backups configured
- [ ] Monitoring and alerting set up

### 8.2 Launch Day
- [ ] Submit final build to App Review
- [ ] Prepare social media announcements
- [ ] Monitor crash reports
- [ ] Monitor backend performance
- [ ] Respond to user reviews
- [ ] Be ready for hotfix if needed

### 8.3 Post-Launch (Week 1-4)
- [ ] Monitor analytics and user behavior
- [ ] Address critical bugs immediately
- [ ] Collect user feedback
- [ ] Plan version 1.1 features
- [ ] Optimize based on usage data

---

## 9. Post-MVP Features (Future Releases)

### Version 1.1 (Month 2-3) - Enhanced Tracking
Priority: Address user feedback from MVP first
- **Background location tracking** (requires "Always Allow" permission)
- **Auto-pause detection** (automatically pause when stopped)
- **Heart rate integration** via HealthKit
- **Photos on activities** (add photos during/after recording)
- **Weather data** (temperature, conditions during activity)
- **Achievement celebrations** (first 5K, 10K, personal records)
- **Activity statistics trends** (weekly/monthly progress)

### Version 1.2 (Month 4-5) - Social Features
- **Follow/followers system**
- **Activity feed** (see friends' activities)
- **Kudos/likes** on activities
- **Comments** on activities
- **Privacy controls** (public/friends-only/private)
- **Activity sharing** to social media

### Version 1.3 (Month 6+) - Advanced Features
- **Segments** (compete on specific route sections)
- **Leaderboards** (by segment, overall stats)
- **Route history** (save and re-run favorite routes)
- **Training plans** (structured workout programs)
- **Goals and challenges** (monthly distance goals, challenges)
- **Interval training** (guided workouts with intervals)

### Version 2.0 (Month 9-12) - Monetization & Expansion
- **Premium subscription** ($5-10/month):
  - Advanced analytics and insights
  - Training plans and coaching
  - Unlimited photo uploads
  - Export to other platforms
  - Priority support
- **Apple Watch companion app**
- **Indoor activity support** (treadmill, gym)
- **Multi-sport support** (swimming, skiing, etc.)
- **Integration with other services** (Strava export, Garmin sync)

---

## 10. Team & Resources

### 10.1 Recommended Team (MVP)
- 1 iOS Developer (can be solo for MVP)
- 1 Backend Developer (if custom backend)
- 1 UI/UX Designer (part-time or contract)
- QA testing (can be developer initially)

### 10.2 Timeline
- **MVP Development**: 14 weeks (Phases 1-8)
- **Testing**: 2 weeks (Phase 9)
- **App Store Preparation**: 2 weeks (Phase 10)
- **Beta Testing**: 2-3 weeks (overlaps with testing)
- **App Review**: 1-2 weeks (Phase 10-11)
- **Total to Launch**: ~17-18 weeks (4-4.5 months)
- **Buffer for unexpected issues**: Built into phase estimates

### 10.3 Detailed Budget Breakdown

**One-Time Costs:**
| Item | Cost | Notes |
|------|------|-------|
| Apple Developer Program | $99/year | Required for App Store |
| App Icon Design | $50-200 | Fiverr/99designs or DIY |
| UI/UX Design (optional) | $0-500 | Contract designer or DIY |
| Domain Name | $10-15/year | For privacy policy hosting |
| **Total One-Time** | **$160-815** | |

**Monthly Recurring Costs:**

| Service | 0-100 Users | 500 Users | 1K Users | 5K Users | 10K Users |
|---------|-------------|-----------|----------|----------|-----------|
| Firebase (Firestore, Auth, Storage) | Free | ~$5 | ~$15 | ~$75 | ~$150 |
| Firebase Hosting (privacy policy) | Free | Free | Free | Free | Free |
| Email Service (SendGrid/Mailgun) | Free | $10 | $15 | $20 | $30 |
| Domain Hosting | $4 | $4 | $4 | $4 | $4 |
| Elevation API (optional) | $0-5 | $5-10 | $10-20 | $30-50 | $60-100 |
| **Total Monthly** | **$4-9** | **$24-29** | **$44-54** | **$129-149** | **$244-284** |

**Firebase Cost Breakdown (Estimated):**

| Metric | Free Tier | 100 Users | 500 Users | 1K Users | 5K Users |
|--------|-----------|-----------|-----------|----------|----------|
| Firestore Reads | 50K/day | 35K/day | 180K/day | 370K/day | 1.8M/day |
| Firestore Writes | 20K/day | 4K/day | 20K/day | 40K/day | 200K/day |
| Storage | 1GB | 0.5GB | 2GB | 5GB | 20GB |
| **Est. Cost** | **$0** | **$0** | **$5** | **$15** | **$75** |

**Assumptions:**
- Each user records 2-3 activities per week
- Each activity = 1000 GPS points average
- Users open app 4-5 times per week
- 50% of reads served from cache (offline persistence)

**Budget Recommendations:**
- **Initial Budget**: $1,000 (covers development tools, testing, design)
- **Monthly Runway**: $500 for first 6 months (covers up to 5K users)
- **Monitor Firebase usage** closely in first month
- **Set up billing alerts** at $10, $50, $100 thresholds

**Cost Optimization Strategies:**
- Use Firestore offline persistence aggressively (reduces reads by 50-70%)
- Implement pagination (don't load all activities at once)
- Compress GPS routes before upload
- Use Firebase free tier for first 100 users (validate product-market fit)

---

## 11. Risk Mitigation

### 11.1 Technical Risks
- **GPS inaccuracy**: Test extensively, implement smoothing algorithms
- **Battery drain**: Profile early and optimize continuously
- **App rejection**: Follow guidelines strictly, prepare for iteration
- **Backend costs**: Start with Firebase free tier, monitor usage

### 11.2 Product Risks
- **User acquisition**: Plan marketing strategy early
- **Competition**: Focus on unique value prop and user experience
- **Retention**: Implement analytics to understand user behavior early

---

## 12. Success Metrics

### 12.1 Launch Metrics (Month 1)
- 100+ downloads
- 50+ active users (recorded at least one activity)
- < 5% crash rate
- 4.0+ App Store rating

### 12.2 Growth Metrics (Month 3)
- 500+ downloads
- 250+ monthly active users
- 10+ activities per user on average
- < 2% crash rate
- 4.5+ App Store rating

---

## Next Steps

1. **Immediate**: Review and approve this updated plan
2. **Week 1**: Begin Phase 1 (Project Setup)
   - Create Xcode project
   - Set up Firebase
   - Configure project structure
3. **Week 2-3**: Begin Phase 2 (Authentication & Onboarding)
   - Implement Firebase Auth
   - Build onboarding flow
4. **Week 4**: Begin Phase 3 (GPS & Location Foundation)
   - Implement LocationService
   - Build Kalman filter
   - Test GPS accuracy
5. **Ongoing**: Track progress against phase milestones weekly
6. **Ongoing**: Review and adjust timeline as needed biweekly

---

## Revision History

### Version 2.0 (December 29, 2025) - Major Update
**Changes based on critical review:**

1. **Timeline Extended**: 10-11 weeks → 17-18 weeks
   - Added buffer for GPS testing and unexpected issues
   - More realistic for solo developer

2. **MVP Features Enhanced**:
   - ✅ Added: Dark mode support (standard iOS feature)
   - ✅ Added: Activity splits (pace per km/mi)
   - ✅ Added: GPX export functionality
   - ✅ Added: Crash recovery with auto-save
   - ✅ Added: Onboarding flow with permission explanations
   - ✅ Added: Data export and account deletion (GDPR compliance)
   - ⚠️ Deferred: Background tracking to v1.1 (reduce MVP complexity)

3. **Technical Architecture Simplified**:
   - Removed Core Data (using Firestore offline persistence instead)
   - Added CrashRecoveryService for auto-save functionality
   - Added GPXExporter utility
   - Added KalmanFilter for GPS smoothing

4. **GPS Implementation Detailed**:
   - Added Kalman filter for GPS smoothing
   - Added signal loss handling
   - Added elevation gain calculation strategy
   - Added stationary detection
   - Added comprehensive GPS testing protocol

5. **Privacy & Compliance**:
   - Added GDPR compliance features
   - Added data export functionality
   - Added account deletion with full data removal
   - Added Firebase Security Rules examples
   - Added detailed privacy policy requirements

6. **Budget Updated**:
   - Added detailed cost breakdowns by user count
   - Added Firebase usage projections
   - Added realistic monthly costs ($4-284 depending on scale)
   - Initial budget: $1,000 (up from $200-500)
   - Monthly runway: $500 for first 6 months

7. **Testing Enhanced**:
   - Added GPS-specific testing scenarios
   - Added accuracy validation requirements (±2%)
   - Added battery drain targets (<10% per hour)
   - Added comprehensive testing checklist

8. **Development Phases Restructured**:
   - Split Authentication into 2 weeks (added onboarding)
   - Added dedicated GPS foundation phase (Week 4)
   - Extended Activity Recording to 2 weeks
   - Extended Activity Management to 2 weeks
   - Extended Polish & Optimization to 2 weeks
   - Extended Testing to 2 weeks
   - Extended App Store Prep to 2 weeks
   - Extended Launch & Monitoring to 2 weeks

### Version 1.0 (December 29, 2025) - Initial Release
Original production plan created.

---

**Document Version**: 2.0
**Last Updated**: December 29, 2025
**Owner**: Development Team
**Status**: Ready for Implementation
