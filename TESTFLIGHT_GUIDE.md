# TestFlight Setup Guide for Trek

**Created**: December 29, 2025
**App Version**: 1.0.0

## Overview

This guide walks through setting up TestFlight for beta testing Trek before the official App Store launch. TestFlight allows you to distribute your app to up to 10,000 testers before public release.

## Prerequisites

Before starting TestFlight setup:

- [ ] Active Apple Developer Program membership ($99/year)
- [ ] App Store Connect account
- [ ] Trek app with valid Bundle ID
- [ ] Signing certificates configured
- [ ] App builds successfully in Xcode
- [ ] All privacy policies and URLs ready

## Part 1: App Store Connect Setup

### Step 1: Create App Record

If not already created:

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Go to **My Apps** → Click **+** → **New App**
3. Fill in details:
   - **Platform**: iOS
   - **Name**: Trek
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select your Bundle ID
   - **SKU**: TREK-001 (or your chosen SKU)
   - **User Access**: Full Access

### Step 2: Complete App Information

Navigate to your app → **App Information**:

**Required Fields**:
- [ ] Privacy Policy URL
- [ ] Category: Health & Fitness
- [ ] Content Rights
- [ ] Age Rating (complete questionnaire → 4+)

### Step 3: Prepare TestFlight Information

Go to **TestFlight** tab:

**Test Information**:
- **Beta App Name**: Trek (or "Trek Beta")
- **Beta App Description**:
```
Trek Beta - GPS Fitness Tracker

Thank you for beta testing Trek! This version is for testing purposes only.

WHAT TO TEST:
• GPS accuracy during activities
• Activity recording and saving
• Maps and route visualization
• Offline functionality
• Overall app stability

WHAT TO FOCUS ON:
• Does GPS tracking feel accurate?
• Are the stats (distance, pace) reliable?
• Any crashes or freezes?
• Is the UI intuitive and easy to use?
• Battery drain during recording

HOW TO PROVIDE FEEDBACK:
• Use the Feedback option in TestFlight app
• Screenshot any bugs or issues
• Email beta@trekapp.com with detailed feedback

KNOWN LIMITATIONS IN BETA:
• Some features may be incomplete
• Performance optimizations ongoing
• UI polish in progress

Thank you for helping make Trek better!
```

- **Feedback Email**: beta@trekapp.com
- **Beta App Review Information**: Same as App Store review info

**Test Details**:
```
Trek requires location permission to record GPS activities.
Please grant "While Using the App" permission when prompted.

To test:
1. Create an account
2. Go to Record tab
3. Select activity type (Run/Ride/Walk/Hike)
4. Tap Start and walk/run briefly
5. Tap Finish to see activity summary
6. Check Activities tab to see recorded activity
```

## Part 2: Certificates and Provisioning

### Step 1: Development Certificate

In Xcode:
1. **Xcode** → **Preferences** → **Accounts**
2. Select your Apple ID
3. Select your team
4. Click **Manage Certificates**
5. Click **+** → **Apple Development**

### Step 2: Distribution Certificate

1. In **Manage Certificates**, click **+**
2. Select **Apple Distribution**
3. Certificate will be created automatically

### Step 3: Provisioning Profile

Xcode handles this automatically, but you can verify:

1. Go to **Signing & Capabilities** in project settings
2. Select **Release** configuration
3. Ensure **Automatically manage signing** is checked
4. Or manually select provisioning profile

## Part 3: Build for TestFlight

### Step 1: Prepare Build Configuration

**Check Build Settings**:

1. Select Trek project in Xcode
2. Select Trek target
3. Select **Release** configuration
4. Verify:
   - [ ] Bundle Identifier: `com.yourcompany.trek`
   - [ ] Version: 1.0.0
   - [ ] Build: 1 (increment for each upload)
   - [ ] Deployment Target: iOS 16.0
   - [ ] Architectures: Standard (arm64)

### Step 2: Archive the App

**Create Archive**:

1. In Xcode, select **Any iOS Device (arm64)** as destination
   - **Not** a specific simulator
   - Not a connected device
2. **Product** → **Clean Build Folder** (Cmd + Shift + K)
3. **Product** → **Archive** (Cmd + Shift + B won't work, must use Archive)
4. Wait for build to complete (2-5 minutes)

**Troubleshooting Common Issues**:

**Issue**: "Archive" is grayed out
- **Solution**: Ensure "Any iOS Device" is selected, not simulator

**Issue**: Build fails with signing error
- **Solution**: Check Signing & Capabilities → Ensure team is selected

**Issue**: "No matching provisioning profiles found"
- **Solution**: Enable "Automatically manage signing"

### Step 3: Validate Archive

When archive completes:

1. Xcode **Organizer** window opens automatically
2. Select your archive
3. Click **Validate App**
4. Choose distribution method: **App Store Connect**
5. Choose signing: **Automatically manage signing**
6. Click **Validate**
7. Wait for validation (1-2 minutes)

**Validation Checks**:
- App signature is valid
- Provisioning profiles are correct
- APIs are used correctly
- Bundle ID matches

If validation succeeds, proceed to upload.

### Step 4: Upload to App Store Connect

1. In Organizer, click **Distribute App**
2. Choose **App Store Connect**
3. Choose **Upload**
4. Signing: **Automatically manage signing**
5. Review app information
6. Click **Upload**
7. Wait for upload to complete (5-15 minutes depending on connection)

**Upload Progress**:
- Preparing app...
- Uploading...
- Processing...

**Success**: "Upload Successful" message appears

### Step 5: Wait for Processing

After upload:
1. Go to App Store Connect
2. Navigate to your app → **TestFlight** tab
3. Build will show as "Processing" (yellow dot)
4. **Wait**: 5-30 minutes for processing
5. You'll receive email when processing completes

**Email Subject**: "Your build has finished processing"

## Part 4: Configure TestFlight Build

### Step 1: Select Build for Testing

When processing completes:

1. Go to **App Store Connect** → **TestFlight**
2. Under **iOS Builds**, you'll see your build
3. Build status: **Ready to Submit** or **Ready to Test**

### Step 2: Add Test Information

Click on your build:

**What to Test** (Release Notes):
```
Trek v1.0.0 (Build 1)

NEW IN THIS BUILD:
• GPS activity tracking for running, cycling, walking, hiking
• Real-time stats: distance, pace, speed, elevation
• Beautiful route maps with start/finish markers
• Activity history with search and filters
• Profile statistics and progress tracking
• Full offline support with automatic sync
• Dark mode support
• GPX export

PLEASE TEST:
1. Activity Recording
   - Start a recording and walk/run for 5-10 minutes
   - Check if distance and pace seem accurate
   - Try pausing and resuming
   - Verify GPS signal quality indicator

2. Maps & Routes
   - View your route on the map
   - Check if route path looks accurate
   - Verify start/end markers appear

3. Activity Management
   - Browse your activity history
   - Try searching activities
   - Test filtering by type
   - Edit activity name and details

4. Offline Mode
   - Enable Airplane Mode
   - Record an activity
   - Check if it saves locally
   - Disable Airplane Mode and verify sync

5. Profile & Stats
   - Check lifetime statistics
   - Verify total distance/time is accurate
   - Try changing unit preferences (metric/imperial)

KNOWN ISSUES:
• None currently

FOCUS AREAS:
• GPS accuracy
• Battery drain (measure after 30-60 min recording)
• UI bugs or unclear elements
• Any crashes

Report issues via TestFlight feedback or beta@trekapp.com

Thank you for testing! 🏃‍♀️🚴‍♂️
```

### Step 3: Export Compliance

If prompted:

**Question**: "Is your app designed to use cryptography or does it contain or incorporate cryptography?"
**Answer**: Yes

**Question**: "Does your app qualify for any of the exemptions?"
**Answer**: Yes - Uses standard iOS encryption (HTTPS)

**Question**: "Does your app implement any encryption?"
**Answer**: No custom encryption (standard iOS only)

## Part 5: Invite Testers

### Option 1: Internal Testing (Recommended First)

**Internal Testers**:
- Up to 100 testers
- Must have role in App Store Connect (Admin, Developer, Marketing, etc.)
- Can test immediately (no App Review required)
- Best for initial testing by your team

**Steps**:
1. Go to **TestFlight** → **Internal Testing**
2. Click **+** to create Internal Testing group
3. Name: "Trek Team" or "Internal Testers"
4. **Select Builds**: Choose your build
5. **Add Testers**: Add email addresses
6. Click **Save**

Testers will receive email invitation immediately.

### Option 2: External Testing (Public Beta)

**External Testers**:
- Up to 10,000 testers
- Can invite via email or public link
- **Requires Beta App Review** (1-2 days)
- For wider beta testing

**Steps**:
1. Go to **TestFlight** → **External Testing**
2. Click **+** to create External Testing group
3. Name: "Trek Public Beta"
4. **Enable automatic distribution** (optional)
5. **Add build**
6. **Submit for Review**

**Beta App Review**:
- Submitted to Apple for review
- Usually approved in 1-2 days
- Faster than full App Review
- Required before external testers can join

**After Approval**:
- Add testers by email, or
- Create public link for anyone to join

### Creating Public Link

For open beta:

1. In External Testing group, click **Public Link**
2. Enable **Public Link**
3. **Max Testers**: Set limit (e.g., 100, 500, or 10,000)
4. Copy link: `https://testflight.apple.com/join/XXXXXXXX`
5. Share link on:
   - Website
   - Social media
   - Reddit, Product Hunt
   - Email newsletters

## Part 6: Tester Experience

### What Testers See

**Email Invitation**:
```
You're invited to test Trek

[Your Name] has invited you to test Trek using TestFlight.

How to get started:
1. Download TestFlight from the App Store
2. Open this invitation
3. Accept and install Trek

Get Started
```

**In TestFlight App**:
1. Tester opens TestFlight
2. Sees "Trek" with Install button
3. Taps Install → App downloads
4. Can view release notes
5. Can send feedback via TestFlight

### Collecting Feedback

**Testers can provide feedback via**:
1. **TestFlight app**: Screenshots + comments
2. **Email**: Responses to your beta email
3. **Crash reports**: Automatically sent to you

**Access Feedback**:
- App Store Connect → TestFlight → Build → Feedback
- View screenshots and comments
- View crash reports

## Part 7: Managing Beta Builds

### Uploading New Builds

**For each new build**:

1. Increment build number in Xcode
   - Version: 1.0.0 (same)
   - Build: 2, 3, 4... (increment)
2. Archive and upload (same process as above)
3. Wait for processing
4. Update "What to Test" notes
5. Add build to testing groups

**Builds automatically go to testers if**:
- Auto-distribution is enabled
- Tester is in group with new build

### Build Management Best Practices

**Version Numbering**:
- **Version** (CFBundleShortVersionString): User-facing (1.0.0, 1.1.0)
- **Build** (CFBundleVersion): Internal (1, 2, 3...)

**Example Timeline**:
```
Build 1 - v1.0.0 - Initial internal test
Build 2 - v1.0.0 - Bug fixes
Build 3 - v1.0.0 - More fixes
Build 4 - v1.0.0 - External beta
Build 5 - v1.0.0 - Final pre-release
Build 6 - v1.0.0 - App Store submission
```

### Beta Testing Timeline

**Week 1**:
- Upload Build 1
- Internal testing (5-10 testers)
- Fix critical bugs

**Week 2**:
- Upload Build 2-3 with fixes
- Submit for Beta App Review
- Launch external beta

**Week 3**:
- Collect feedback from external testers
- Fix bugs, improve UX
- Upload Build 4-5

**Week 4**:
- Final build (Build 6)
- Submit to App Store

## Part 8: TestFlight Limits & Policies

### Limitations

**Tester Limits**:
- Internal: 100 testers per app
- External: 10,000 testers per app
- Testers can test up to 30 apps at once

**Build Expiration**:
- Each build expires after **90 days**
- Testers must update to newer build
- Cannot extend expiration

**Testing Groups**:
- Up to 100 groups
- Each group can have multiple builds

### Policies

**TestFlight Review Guidelines**:
- No crashes in critical flows
- App must work as described
- No placeholder content
- Privacy Policy must be available

**Prohibited**:
- Apps that crash on launch
- Apps with no functionality
- Apps intended only for distribution (must plan App Store release)

## Part 9: Monitoring & Analytics

### TestFlight Metrics

**Available Metrics**:
- Number of testers
- Number of installs
- Number of sessions
- Crashes
- Feedback count

**Access Metrics**:
App Store Connect → TestFlight → Build → Metrics

### Crashlytics Integration

Since Trek uses Firebase Crashlytics:

**Track Beta Testers**:
```swift
// In TrekApp.swift
#if DEBUG
Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
#endif

// Tag beta builds
Crashlytics.crashlytics().setCustomValue("beta", forKey: "build_type")
Crashlytics.crashlytics().setCustomValue(buildNumber, forKey: "build_number")
```

**View Crashes**:
Firebase Console → Crashlytics → Crashes

## Part 10: Preparing for App Store

### When Beta is Ready

After beta testing (2-4 weeks):

**Checklist**:
- [ ] All critical bugs fixed
- [ ] Performance optimized
- [ ] Battery usage acceptable
- [ ] GPS accuracy validated
- [ ] Positive tester feedback
- [ ] No crashes in normal usage
- [ ] All features working
- [ ] Privacy Policy finalized
- [ ] Screenshots created
- [ ] App description written

### Final Build Submission

1. Create final build (increment build number)
2. Upload to App Store Connect
3. **Do not add to TestFlight groups**
4. Instead, submit for **App Review**

**Steps**:
1. App Store Connect → Your App → **App Store** tab
2. Click **+** next to **iOS App**
3. Select **Final Build**
4. Complete all metadata
5. Submit for Review

## Troubleshooting

### Common TestFlight Issues

**Issue**: "No builds available"
- **Solution**: Wait for processing (check email)
- **Solution**: Check if build expired (90 days)

**Issue**: "Cannot install build"
- **Solution**: Device OS version must match minimum deployment target
- **Solution**: Check if device UDID is registered (for internal)

**Issue**: "TestFlight is full"
- **Solution**: Remove inactive testers
- **Solution**: Create new testing group

**Issue**: Build stuck in "Processing"
- **Solution**: Usually resolves in 30 minutes
- **Solution**: If >2 hours, contact Apple Support

**Issue**: Beta App Review Rejected
- **Solution**: Review feedback and fix issues
- **Solution**: Update "Test Information"
- **Solution**: Resubmit with clarifications

## TestFlight Checklist

### Before First Upload
- [ ] App builds successfully
- [ ] Bundle ID is correct
- [ ] Version and build number set
- [ ] Signing certificates configured
- [ ] Test on real device
- [ ] Firebase configured

### For Each Build
- [ ] Increment build number
- [ ] Clean build folder
- [ ] Archive successfully
- [ ] Validate before upload
- [ ] Upload to App Store Connect
- [ ] Update "What to Test" notes

### Managing Testers
- [ ] Create internal testing group
- [ ] Invite team members
- [ ] Test internally first (1 week)
- [ ] Create external testing group
- [ ] Submit for Beta App Review
- [ ] Share public link when ready

### Before App Store Submission
- [ ] Beta testing complete (2-4 weeks)
- [ ] All feedback addressed
- [ ] No critical bugs
- [ ] Performance validated
- [ ] Screenshots prepared
- [ ] Metadata complete

## Resources

### Apple Documentation
- [TestFlight Official Guide](https://developer.apple.com/testflight/)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [TestFlight Beta Testing](https://testflight.apple.com/)

### Helpful Links
- App Store Connect: https://appstoreconnect.apple.com
- Apple Developer: https://developer.apple.com
- TestFlight App: https://apps.apple.com/app/testflight/id899247664

### Support
- **Apple Developer Support**: https://developer.apple.com/support/
- **Phone**: 1-800-633-2152 (US)
- **Email**: Through developer.apple.com

---

## Quick Start Summary

**First-time TestFlight Setup (30 minutes)**:
1. Create app in App Store Connect ✅
2. Configure certificates in Xcode ✅
3. Archive app (Product → Archive) ✅
4. Validate and upload ✅
5. Wait for processing (15-30 min) ⏱️
6. Add testers ✅
7. Start testing! 🎉

**For Each New Build (10 minutes)**:
1. Increment build number
2. Archive and upload
3. Update release notes
4. Builds automatically distribute to testers

---

**Good luck with your beta! TestFlight makes it easy to iterate and improve Trek before launch.** 🚀

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Target**: Trek v1.0.0
