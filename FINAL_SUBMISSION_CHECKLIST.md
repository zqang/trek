# Trek - Final Submission Checklist

**Created**: December 29, 2025
**Version**: 1.0.0
**Build**: 1

## Overview

Complete this checklist before submitting Trek to the App Store. Each section must be 100% complete.

---

## ✅ Phase 1: Firebase Configuration

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Firebase Console Setup

- [ ] Firebase project created
- [ ] iOS app registered in Firebase Console
- [ ] `GoogleService-Info.plist` downloaded
- [ ] `GoogleService-Info.plist` added to Xcode (not in git)
- [ ] `.gitignore` includes `GoogleService-Info.plist`

### Authentication

- [ ] Email/Password provider enabled
- [ ] Apple Sign In configured (optional but recommended)
- [ ] Test signup works
- [ ] Test login works

### Firestore Database

- [ ] Firestore database created
- [ ] Security rules deployed (`firebase/firestore.rules`)
- [ ] 4 composite indexes created and enabled:
  - [ ] userId (ASC) + createdAt (DESC)
  - [ ] userId (ASC) + distance (DESC)
  - [ ] userId (ASC) + duration (DESC)
  - [ ] userId (ASC) + type (ASC) + createdAt (DESC)
- [ ] Indexes status: **Enabled** (green, not "Building")
- [ ] Offline persistence enabled in code ✅
- [ ] Security rules tested (users can't access others' data)

### Firebase Storage

- [ ] Storage enabled
- [ ] Security rules deployed (`firebase/storage.rules`)
- [ ] Test profile photo upload works

### Analytics & Crashlytics

- [ ] Firebase Analytics enabled
- [ ] Crashlytics enabled
- [ ] Test crash reporting (optional)

**Completion Time**: ~30-60 minutes
**Reference**: `FIREBASE_SETUP.md`

---

## ✅ Phase 2: Legal Documents

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Privacy Policy

- [ ] `PRIVACY_POLICY.md` reviewed and accurate
- [ ] Converted to HTML (`privacy.html`)
- [ ] Hosted on live URL
- [ ] URL accessible: ___________________________
- [ ] GDPR compliant (EU users)
- [ ] CCPA compliant (California users)
- [ ] All Firebase services disclosed

### Terms of Service

- [ ] `TERMS_OF_SERVICE.md` reviewed and accurate
- [ ] Converted to HTML (`terms.html`)
- [ ] Hosted on live URL
- [ ] URL accessible: ___________________________
- [ ] Company information filled in
- [ ] Contact email addresses updated

### Website Hosting

**Choose one**:
- [ ] GitHub Pages (`docs/` folder)
- [ ] Firebase Hosting
- [ ] Custom domain
- [ ] Other: ___________________________

**URLs**:
- Marketing URL: ___________________________
- Privacy Policy: ___________________________
- Terms of Service: ___________________________
- Support URL: ___________________________

**Test URLs**:
- [ ] All URLs load successfully
- [ ] Mobile-responsive
- [ ] No broken links
- [ ] Contact emails are correct

**Completion Time**: ~30-60 minutes
**Reference**: `GITHUB_PAGES_SETUP.md`

---

## ✅ Phase 3: App Icons

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Icon Design

- [ ] Icon designed (mountain concept or custom)
- [ ] 1024×1024 PNG exported
- [ ] No transparency (fully opaque)
- [ ] sRGB color space
- [ ] Recognizable at small sizes (40×40)

### All Sizes Generated

**Required sizes**:
- [ ] 40×40 (Notification @2x)
- [ ] 60×60 (Notification @3x)
- [ ] 58×58 (Settings @2x)
- [ ] 87×87 (Settings @3x)
- [ ] 80×80 (Spotlight @2x)
- [ ] 120×120 (Spotlight @3x / App @2x)
- [ ] 180×180 (App @3x)
- [ ] 152×152 (iPad App @2x)
- [ ] 167×167 (iPad Pro App @2x)
- [ ] 1024×1024 (App Store)

### Xcode Integration

- [ ] All icons added to `Assets.xcassets/AppIcon.appiconset`
- [ ] No missing slots in Xcode
- [ ] Build succeeds
- [ ] Icon appears on simulator/device
- [ ] Icon tested in multiple contexts:
  - [ ] Home Screen
  - [ ] Settings
  - [ ] Spotlight search
  - [ ] Notifications

**Completion Time**: ~1-2 hours (design) or ~30 min (using template)
**Reference**: `APP_ICONS_GUIDE.md`, `ICON_CREATION_QUICK_START.md`

---

## ✅ Phase 4: Screenshots

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Screenshot Creation

**6 Required Screenshots** (1290×2796 for iPhone 6.7"):

- [ ] Screenshot 1: Recording Screen (hero shot)
- [ ] Screenshot 2: Activity Summary
- [ ] Screenshot 3: Activities List
- [ ] Screenshot 4: Activity Detail
- [ ] Screenshot 5: Profile & Statistics
- [ ] Screenshot 6: Dark Mode (optional but recommended)

### Sample Data

- [ ] 3-5 sample activities created
- [ ] Realistic activity names (not "Test 1")
- [ ] Varied stats (different distances/times)
- [ ] Routes have GPS data (not blank maps)
- [ ] Profile stats look realistic

### Annotations (Optional)

- [ ] Title text added (72pt, bold, white)
- [ ] Subtitle text added (48pt, regular)
- [ ] Gradient overlay for readability
- [ ] Text doesn't cover important UI
- [ ] Consistent styling across all screenshots

### Quality Check

- [ ] Correct resolution (1290×2796)
- [ ] PNG format
- [ ] No lorem ipsum or placeholders
- [ ] UI looks polished
- [ ] Maps show routes (not blank)
- [ ] All 6 screenshots prepared
- [ ] Files named clearly (01-, 02-, etc.)

**Completion Time**: ~30 min to 2 hours
**Reference**: `SCREENSHOTS_GUIDE.md`, `SCREENSHOT_CREATION_QUICK_START.md`

---

## ✅ Phase 5: App Store Metadata

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Basic Information

- [ ] App Name: **Trek**
- [ ] Subtitle: **Track Your Fitness Journey** (or custom, max 30 chars)
- [ ] Primary Language: English (U.S.)
- [ ] Category: Health & Fitness
- [ ] Secondary Category: Navigation (optional)

### Description

- [ ] Full description written (~2,850 characters)
- [ ] Key features highlighted
- [ ] No typos or grammatical errors
- [ ] Compelling and accurate
- [ ] Includes contact email

### Keywords

- [ ] Keywords optimized (max 100 characters)
- [ ] No repeating words
- [ ] Relevant search terms included
- [ ] Example: `fitness,running,cycling,hiking,gps,tracker,workout,activity,route,map,exercise,training`

### Release Notes

- [ ] "What's New" written for v1.0.0
- [ ] Features list complete
- [ ] Clear and concise
- [ ] Includes "Get Started" instructions

### URLs

- [ ] Marketing URL: ___________________________
- [ ] Support URL: ___________________________
- [ ] Privacy Policy URL: ___________________________

### Age Rating

- [ ] Age rating questionnaire completed
- [ ] Result: 4+ ✅
- [ ] No objectionable content confirmed

**Completion Time**: ~30-60 minutes
**Reference**: `APP_STORE_METADATA.md`

---

## ✅ Phase 6: Performance Testing

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Quick Performance Tests

- [ ] App launch time: _____ seconds (target: < 2s)
- [ ] Memory usage (idle): _____ MB (target: < 150MB)
- [ ] Memory usage (recording): _____ MB (target: < 300MB)
- [ ] Battery drain (60 min): _____% (target: < 30%)

### Instruments Profiling

- [ ] Time Profiler run (no hot spots > 5% CPU)
- [ ] Allocations checked (no continuous growth)
- [ ] Leaks instrument run (0 leaks)
- [ ] Energy Log checked (acceptable battery impact)

### Real Device Testing

- [ ] Tested on iPhone (iOS 16.0+)
- [ ] 30-60 minute GPS recording completed
- [ ] No crashes during testing
- [ ] GPS accuracy acceptable
- [ ] Stats calculate correctly
- [ ] Battery drain acceptable

### Edge Cases

- [ ] Offline mode works
- [ ] Record activity offline → sync when online
- [ ] GPS permission denied → shows message
- [ ] Low battery during recording
- [ ] App backgrounded during recording
- [ ] Device locked during recording

### Unit Tests

- [ ] All 60+ tests pass
- [ ] No test failures
- [ ] Code coverage: ____% (target: 85%+)

**Completion Time**: ~1-2 hours
**Reference**: `PERFORMANCE_TESTING_GUIDE.md`, `PERFORMANCE_OPTIMIZATION.md`

---

## ✅ Phase 7: Code Review

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Security & Privacy

- [ ] No API keys hardcoded in code
- [ ] `GoogleService-Info.plist` in `.gitignore`
- [ ] Firestore security rules deployed and tested
- [ ] Storage security rules deployed
- [ ] No sensitive data logged
- [ ] Passwords never logged

### Code Quality

- [ ] No compilation errors
- [ ] No compilation warnings (or documented)
- [ ] No force unwrapping in critical paths
- [ ] Proper error handling
- [ ] No `// TODO` in critical code
- [ ] No `print()` statements in production (or removed)

### Memory Management

- [ ] Closures use `[weak self]` where appropriate
- [ ] ViewModels managed correctly
- [ ] Firebase listeners removed on deinit
- [ ] No retain cycles (verified with Instruments)

### Feature Completeness

- [ ] Sign up works
- [ ] Login works
- [ ] Activity recording works
- [ ] Activity saving works (online)
- [ ] Activity saving works (offline)
- [ ] Activities list displays
- [ ] Activity detail shows map/stats
- [ ] Profile displays stats
- [ ] Settings save correctly
- [ ] Data export (GPX) works
- [ ] Account deletion works
- [ ] Dark mode works (if supported)

**Completion Time**: ~1-2 hours
**Reference**: `FINAL_CODE_REVIEW.md`

---

## ✅ Phase 8: Demo Account

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Create Demo Account

- [ ] Email: `reviewer@trekapp.com`
- [ ] Password: `ReviewTrek2025!`
- [ ] Account created successfully
- [ ] Can login successfully

### Add Sample Activities

- [ ] 3-5 sample activities added
- [ ] Mix of activity types (Run, Ride, Walk)
- [ ] Realistic names and stats
- [ ] Activities visible when logged in

### Test Demo Account

- [ ] Log out of personal account
- [ ] Log in with demo credentials
- [ ] Activities appear in list
- [ ] Can view activity details
- [ ] Can record new activity
- [ ] All features work

### Document for Review

- [ ] Credentials added to App Review Information
- [ ] Testing instructions written
- [ ] Location permission explained
- [ ] Firebase services disclosed

**Completion Time**: ~10-15 minutes
**Reference**: `DEMO_ACCOUNT_SETUP.md`

---

## ✅ Phase 9: Xcode Configuration

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Project Settings

- [ ] Bundle Identifier correct: `com.yourcompany.trek`
- [ ] Display Name: **Trek**
- [ ] Version: **1.0.0**
- [ ] Build: **1**
- [ ] iOS Deployment Target: **16.0** (or your choice)
- [ ] Devices: iPhone (or Universal)

### Signing & Capabilities

- [ ] Team selected
- [ ] Automatically manage signing: ✅
- [ ] Or: Manual signing configured correctly
- [ ] Provisioning profile valid

### Build Configuration

- [ ] Archive configuration: **Release**
- [ ] Optimization level: `-O` (Release)
- [ ] Strip Debug Symbols: ✅
- [ ] Bitcode: OFF (deprecated in Xcode 14+)

### Info.plist

- [ ] `NSLocationWhenInUseUsageDescription` present and clear
- [ ] `NSPhotoLibraryUsageDescription` present (for profile photo)
- [ ] No placeholder text in descriptions
- [ ] App Transport Security configured (if needed)

**Completion Time**: ~15-30 minutes

---

## ✅ Phase 10: Build & Archive

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Pre-Archive

- [ ] Clean Build Folder (Cmd + Shift + K)
- [ ] Select "Any iOS Device (arm64)" (NOT simulator)
- [ ] Build configuration: Release
- [ ] Version and build number verified

### Archive

- [ ] Product → Archive (Cmd + Option + Shift + B)
- [ ] Archive completes successfully (2-5 min)
- [ ] Archive appears in Organizer

### Validate

- [ ] Click "Validate App"
- [ ] Choose App Store Connect distribution
- [ ] Automatically manage signing (or manual)
- [ ] Validation completes successfully
- [ ] No errors or critical warnings

### Upload

- [ ] Click "Distribute App"
- [ ] Choose "App Store Connect"
- [ ] Choose "Upload"
- [ ] Automatically manage signing
- [ ] Upload completes successfully (5-15 min)
- [ ] Email received: "Your build has finished processing"

### Processing

- [ ] Wait for processing (5-30 minutes)
- [ ] Check App Store Connect → TestFlight
- [ ] Build shows "Processing..." initially
- [ ] Then shows "Ready to Submit" or "Ready to Test"

**Completion Time**: ~30-60 minutes
**Reference**: `TESTFLIGHT_GUIDE.md`

---

## ✅ Phase 11: App Store Connect

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### App Information

- [ ] All metadata entered
- [ ] Screenshots uploaded (all 6)
- [ ] App icon 1024×1024 uploaded
- [ ] Description finalized
- [ ] Keywords optimized
- [ ] Release notes written
- [ ] URLs all working

### Pricing & Availability

- [ ] Price: Free (or set price)
- [ ] Availability: All territories (or select specific)
- [ ] Pre-order: OFF (for v1.0)

### App Review Information

- [ ] Contact information complete
- [ ] Demo account credentials entered
- [ ] Review notes written (detailed)
- [ ] Attachments uploaded (if needed)

### Age Rating

- [ ] Questionnaire completed
- [ ] Age rating: 4+
- [ ] All questions answered accurately

### Export Compliance

- [ ] Encryption question answered
- [ ] Using standard iOS encryption only: ✅
- [ ] No CCATS required

### Build Selection

- [ ] Correct build selected for submission
- [ ] Build version matches (1.0.0)
- [ ] Build number is latest (1)

**Completion Time**: ~30-60 minutes

---

## ✅ Phase 12: Final Checks

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Pre-Submission Verification

**Test one more time**:
- [ ] Demo account login works
- [ ] Sample activities visible
- [ ] Record test activity (2 min walk)
- [ ] Activity saves successfully
- [ ] No crashes

**Review All Information**:
- [ ] App name correct
- [ ] Description accurate
- [ ] Screenshots in correct order
- [ ] URLs all working
- [ ] Contact info correct
- [ ] Demo account tested

**Legal & Compliance**:
- [ ] Privacy Policy accurate and accessible
- [ ] Terms of Service accurate and accessible
- [ ] Age rating appropriate
- [ ] Content is original or properly licensed

**Technical**:
- [ ] Firebase fully configured
- [ ] Indexes enabled
- [ ] Security rules deployed
- [ ] No hardcoded secrets
- [ ] Latest build uploaded

### Submission Readiness

- [ ] All phases 1-11 complete ✅
- [ ] No outstanding issues
- [ ] Ready to submit for review

**Completion Time**: ~30 minutes

---

## ✅ Submission

**Status**: ⬜ Not Started | ⬜ In Progress | ⬜ Complete

### Submit for Review

1. [ ] App Store Connect → Your App → iOS App
2. [ ] Click "Submit for Review"
3. [ ] Review all information one last time
4. [ ] Confirm export compliance
5. [ ] Confirm content rights
6. [ ] Click "Submit"

### Confirmation

- [ ] Submission confirmed
- [ ] Status: "Waiting for Review"
- [ ] Email received: "App Submitted for Review"

### Monitor Status

- [ ] Check App Store Connect daily
- [ ] Watch for email notifications
- [ ] Respond quickly to any reviewer questions

**Typical Review Time**: 1-7 days (usually 24-48 hours)

---

## Post-Submission

### While Waiting for Review

- [ ] Monitor email for review status
- [ ] Prepare marketing materials
- [ ] Plan launch announcement
- [ ] Prepare support resources

### If Rejected

- [ ] Read rejection reason carefully
- [ ] Fix issues mentioned
- [ ] Respond to reviewer (if applicable)
- [ ] Resubmit when ready

### When Approved

- [ ] Release to App Store (or schedule)
- [ ] Announce launch
- [ ] Monitor analytics
- [ ] Respond to user reviews
- [ ] Plan v1.1 updates

---

## Progress Tracker

### Overall Completion

**Phase Status**:
- [ ] Phase 1: Firebase Configuration
- [ ] Phase 2: Legal Documents
- [ ] Phase 3: App Icons
- [ ] Phase 4: Screenshots
- [ ] Phase 5: App Store Metadata
- [ ] Phase 6: Performance Testing
- [ ] Phase 7: Code Review
- [ ] Phase 8: Demo Account
- [ ] Phase 9: Xcode Configuration
- [ ] Phase 10: Build & Archive
- [ ] Phase 11: App Store Connect
- [ ] Phase 12: Final Checks
- [ ] Submission Complete

**Progress**: _____ / 13 phases complete (___%)

### Estimated Time Remaining

**If starting from scratch**:
- Firebase: 60 min
- Legal/Website: 60 min
- Icons: 60-120 min
- Screenshots: 60-120 min
- Metadata: 30 min
- Testing: 120 min
- Demo Account: 15 min
- Xcode/Build: 30 min
- App Store Connect: 60 min

**Total**: ~8-12 hours

**If using guides and templates**: ~4-6 hours

---

## Quick Reference

### Key Files Created

- `firebase/firestore.indexes.json` - Firestore indexes
- `firebase/firestore.rules` - Security rules
- `firebase/storage.rules` - Storage rules
- `docs/privacy.html` - Privacy Policy (hosted)
- `docs/terms.html` - Terms of Service (hosted)
- `docs/support.html` - Support page (hosted)
- `design/icon-template.svg` - App icon template
- `screenshots/01-06.png` - 6 screenshots

### Key Credentials

- Demo Account: `reviewer@trekapp.com` / `ReviewTrek2025!`
- Firebase Project: ___________________________
- App Store Connect: ___________________________

### Key URLs

- Privacy Policy: ___________________________
- Terms of Service: ___________________________
- Support: ___________________________

---

## Final Pre-Submission Checklist

**BEFORE clicking "Submit for Review"**:

- [ ] All 13 phases complete
- [ ] Demo account tested and works
- [ ] All URLs accessible
- [ ] Screenshots look professional
- [ ] No typos in description
- [ ] Build number is correct
- [ ] Firebase indexes enabled
- [ ] Security rules deployed
- [ ] No crashes in testing
- [ ] Ready for review! ✅

---

## Success!

When all checkboxes are ✅, you're ready to submit Trek to the App Store!

**Good luck with your launch! 🚀**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Completion Time**: 4-12 hours (depending on experience and resources)
