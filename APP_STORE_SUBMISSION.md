# Trek - App Store Submission Guide

**Created**: December 29, 2025
**Version**: 1.0.0
**Build**: 1

## Overview

Complete step-by-step guide to submit Trek to the App Store for the first time.

---

## Prerequisites

Before starting, ensure ALL these are complete:

✅ All items in `FINAL_SUBMISSION_CHECKLIST.md` checked
✅ Build uploaded to App Store Connect and processed
✅ Firebase fully configured
✅ Legal documents hosted and accessible
✅ App icons and screenshots ready
✅ Demo account created and tested

**Estimated Time**: 30-45 minutes for submission process

---

## Step 1: Access App Store Connect

### Login

1. Go to [appstoreconnect.apple.com](https://appstoreconnect.apple.com)
2. Sign in with your Apple ID
3. Click "My Apps"

### Select Your App

- If first submission: Click "+ New App"
- If app already created: Click "Trek"

---

## Step 2: Create App (First Time Only)

Skip this if your app already exists in App Store Connect.

### New App Form

1. Click "+ New App" button
2. Select platforms:
   - ✅ iOS
   - ⬜ tvOS (unless supporting)
   - ⬜ macOS (unless supporting)

3. Fill in details:
   - **Name**: Trek
   - **Primary Language**: English (U.S.)
   - **Bundle ID**: Select `com.yourcompany.trek`
   - **SKU**: TREK-001 (or any unique identifier)
   - **User Access**: Full Access

4. Click "Create"

---

## Step 3: App Information

### Basic Information

Navigate to: **App Information** (left sidebar)

**Name**: Trek
**Subtitle**: Track Your Fitness Journey
**Privacy Policy URL**: [Your hosted privacy.html URL]
**Category**:
- Primary: Health & Fitness
- Secondary: Navigation (optional)

### General Information

**Bundle ID**: com.yourcompany.trek (auto-filled)
**SKU**: TREK-001
**Apple ID**: (auto-generated)

### Age Rating

Click "Edit" next to Age Rating:

Answer questionnaire:
- Cartoon/Fantasy Violence: None
- Realistic Violence: None
- Sexual Content: None
- Profanity: None
- Alcohol/Tobacco/Drugs: None
- Mature/Suggestive Themes: None
- Horror/Fear Themes: None
- Medical Treatment: None
- Gambling: None
- Unrestricted Web Access: No
- User Generated Content: No
- **Location Services: YES**

**Result**: 4+

Click "Done"

### Save

Click "Save" (top right)

---

## Step 4: Pricing and Availability

Navigate to: **Pricing and Availability**

### Price

- **Price**: Free (or select tier if paid)
- **Pre-Order**: No (for v1.0)

### Availability

**Countries and Regions**:
- Select All (default)
- Or choose specific countries

**App Distribution**:
- Available to everyone (default)

### Save

Click "Save"

---

## Step 5: Prepare for Submission

Navigate to: **iOS App** → **1.0 Prepare for Submission**

### Screenshots and App Preview

**iPhone 6.7" Display** (required):
1. Drag and drop 6 screenshots in order:
   - Screenshot 1: Recording (this shows first!)
   - Screenshot 2: Summary
   - Screenshot 3: List
   - Screenshot 4: Detail
   - Screenshot 5: Profile
   - Screenshot 6: Dark Mode

2. Preview how they appear
3. Ensure first screenshot is the most compelling

**Optional** (but recommended):
- iPhone 6.5" Display screenshots
- iPad Pro 12.9" Display screenshots (if supporting iPad)

### Promotional Text

(170 characters, can update without new version):

```
Record runs, rides, and hikes with precise GPS tracking. View beautiful route maps, track your progress, and achieve your fitness goals. Start your journey today!
```

### Description

(4000 characters max):

Copy from `APP_STORE_METADATA.md` - Full Description section

**Key sections**:
- Introduction
- KEY FEATURES (bulleted)
- PERFECT FOR (bulleted)
- WHY CHOOSE TREK
- TECHNICAL FEATURES
- GET STARTED TODAY
- FREE TO USE
- Contact info

### Keywords

(100 characters max, comma-separated, no spaces):

```
fitness,running,cycling,hiking,gps,tracker,workout,activity,route,map,exercise,training
```

### Support URL

```
https://yourusername.github.io/trek/support.html
```
(or your hosted support page)

### Marketing URL (Optional)

```
https://yourusername.github.io/trek/
```

---

## Step 6: What's New in This Version

(Release Notes, 4000 characters max):

Copy from `APP_STORE_METADATA.md` - What's New (Version 1.0.0) section

**Example**:
```
Welcome to Trek 1.0!

Trek is your new personal fitness companion for tracking all your activities.

✨ NEW FEATURES

GPS Activity Tracking
• Record runs, rides, walks, and hikes with precise GPS tracking
• Real-time pace, speed, distance, and elevation

Beautiful Route Maps
• Interactive maps with your complete route
• Start and finish markers
• Elevation profiles

[...continue with full release notes...]

Happy tracking! 🏃‍♀️🚴‍♂️⛰️
```

---

## Step 7: Build

### Select Build

**Build** section:
1. Click "+ Build" (or click existing build if already selected)
2. Select latest build (1.0.0, Build 1)
3. Click "Done"

### Export Compliance

When prompted:

**Question**: "Is your app designed to use cryptography?"
**Answer**: Yes

**Question**: "Does your app qualify for any exemptions?"
**Answer**: Yes - Uses standard iOS encryption (HTTPS only)

**Question**: "Does your app implement proprietary encryption?"
**Answer**: No

Click "Start Internal Testing" (if prompted) - can skip for now

---

## Step 8: General App Information

### App Icon

- Should auto-fill from your build
- Verify 1024×1024 icon displays correctly

### Version

- **Version**: 1.0.0 (auto-filled from build)
- **Copyright**: © 2025 Trek App (or your company name)

### Trade Representative Contact Information

(Required in some regions):

- First Name: [Your name]
- Last Name: [Your name]
- Address Line 1: [Your address]
- City/Town: [City]
- State/Province: [State]
- Postal Code: [ZIP]
- Country: [Country]
- Phone Number: [Your phone]
- Email: [Your email]

---

## Step 9: App Review Information

**Critical section** - Apple reviewers use this!

### Contact Information

- **First Name**: [Your first name]
- **Last Name**: [Your last name]
- **Phone Number**: [Your phone with country code]
- **Email Address**: support@trekapp.com

### Demo Account

✅ **Sign-in required**

**Username**: reviewer@trekapp.com
**Password**: ReviewTrek2025!

### Notes

(Detailed instructions for reviewers):

```
DEMO ACCOUNT:
Email: reviewer@trekapp.com
Password: ReviewTrek2025!

The demo account has 3-5 sample activities pre-loaded.

HOW TO TEST TREK:

1. Launch Trek
2. Tap "Login" (not Sign Up)
3. Enter demo credentials above
4. Grant location permission when prompted ("While Using the App")
5. Navigate to "Activities" tab to see sample workouts
6. Tap "Record" to test activity tracking
7. Select activity type (Run, Ride, Walk, or Hike)
8. Tap "Start" to begin recording
9. Walk around briefly (2-3 minutes) to generate GPS data
10. Tap "Finish" to complete recording
11. View activity summary and stats

LOCATION PERMISSION:

Trek requires location permission "While Using the App" to record GPS coordinates during activities. This is ONLY used when actively recording an activity. There is no background location tracking except during active recording sessions initiated by the user.

Location data is:
- Only collected during active recording
- Stored in Firebase Firestore for the user's account
- Used to display routes on maps and calculate stats
- Never shared with third parties
- Can be exported by the user in GPX format
- Can be deleted by the user

FIREBASE SERVICES:

Trek uses Firebase for backend services:
- **Firebase Authentication**: User accounts (email/password, Apple Sign In)
- **Cloud Firestore**: Activity data storage with offline persistence
- **Cloud Storage**: Profile photos (optional, user-controlled)
- **Firebase Analytics**: Usage analytics (can be opted out in Settings)
- **Firebase Crashlytics**: Crash reporting for bug fixes

All Firebase usage complies with our Privacy Policy.

OFFLINE FUNCTIONALITY:

Trek works fully offline. Activities are saved locally and automatically sync when the device reconnects to the internet. This can be tested by:
1. Enabling Airplane Mode
2. Recording an activity
3. Saving the activity (saves locally)
4. Disabling Airplane Mode
5. Activity syncs automatically within 10 seconds

TEST SCENARIOS:

• Record a 2-5 minute activity (walk around)
• View activity list and details
• Edit an activity name
• Delete an activity
• View profile statistics
• Export activity as GPX
• Change settings (units, privacy)
• Test offline mode as described above

KNOWN LIMITATIONS (by design for v1.0):

• Foreground-only GPS tracking (no background tracking except during active recording)
• No social features (planned for v1.1)
• No route planning (planned for v1.1)

For any questions during review, please contact support@trekapp.com

Thank you!
```

### Attachments

(Optional, upload if needed):
- Screenshots explaining special features
- Demo video (if helpful)
- Additional documentation

---

## Step 10: Version Release

### After Approval

Choose release method:

**Option 1: Automatically release** (recommended for v1.0)
- ⬤ Automatically release this version

**Option 2: Manually release**
- ⬤ Manually release this version
  - You control exact release time after approval

**Option 3: Schedule release**
- ⬤ Automatically release on [date]
  - Set specific date/time

Select one and save.

---

## Step 11: Final Review

### Before Submitting

**Review everything one last time**:

- [ ] Screenshots look professional
- [ ] Description is accurate and compelling
- [ ] Keywords optimized
- [ ] Demo account credentials correct
- [ ] Review notes detailed and helpful
- [ ] Contact information correct
- [ ] All URLs working
- [ ] Build selected (1.0.0, Build 1)
- [ ] Age rating correct (4+)
- [ ] Export compliance answered

### Check for Warnings

- Yellow warnings: Review and address if possible
- Red errors: Must fix before submission

---

## Step 12: Submit for Review

### Submit Button

1. Scroll to top of page
2. Click "Add for Review" (if needed)
3. Click "Submit for Review" button (top right)

### Confirmation Dialog

Review final confirmation:
- ✅ Export Compliance confirmed
- ✅ Content Rights confirmed
- ✅ Advertising Identifier (should be "No" for Trek)

Click "Submit"

### Success!

**Confirmation**:
- Status changes to "Waiting for Review"
- Email sent: "App Submitted for Review"
- Estimated review time: 24-48 hours (can be 1-7 days)

---

## Step 13: Monitor Review Status

### App Store Connect

Check status:
1. **In Review**: Apple is reviewing (typically 8-24 hours in this state)
2. **Pending Developer Release**: Approved! (if manual release)
3. **Ready for Sale**: Live on App Store!

### Rejection

If status changes to "Rejected":
1. Read rejection reason carefully (in Resolution Center)
2. Fix issues mentioned
3. Respond to reviewer if applicable
4. Click "Submit for Review" again when ready

### Common Rejection Reasons

**Location Permission**:
- Solution: Ensure NSLocationWhenInUseUsageDescription is clear
- Solution: Explain usage in Review Notes

**Crashes**:
- Solution: Test thoroughly before resubmission
- Solution: Fix crash and upload new build

**Incomplete Features**:
- Solution: Ensure all features work
- Solution: Demo account has sample data

**Misleading Content**:
- Solution: Ensure screenshots match actual app
- Solution: Description is accurate

---

## Step 14: After Approval

### Manual Release

If you chose "Manually release":
1. App Store Connect → Your App → iOS App
2. Status: "Pending Developer Release"
3. Click "Release This Version"
4. App goes live within 24 hours

### Automatic Release

- App automatically goes live after approval
- Typically within 24 hours of approval

### Verify Live

1. Open App Store on iPhone
2. Search for "Trek"
3. Verify app appears
4. Download and test

---

## Post-Launch Checklist

### Monitor

- [ ] Check App Store listing
- [ ] Verify all info displays correctly
- [ ] Download and test from App Store
- [ ] Monitor Firebase Analytics
- [ ] Monitor Crashlytics for crashes
- [ ] Watch for user reviews

### Respond

- [ ] Respond to user reviews (especially negative ones)
- [ ] Fix critical bugs quickly
- [ ] Plan v1.0.1 if needed
- [ ] Gather user feedback

### Market

- [ ] Announce launch (social media, website, email)
- [ ] Share App Store link
- [ ] Ask friends/family to download and review
- [ ] Submit to app review sites
- [ ] Create Product Hunt launch (optional)

---

## Version Updates (Future)

### For v1.0.1, v1.1, etc.

1. Increment version/build number in Xcode
2. Archive and upload new build
3. App Store Connect → Version → Create new version
4. Fill in "What's New" (describe changes)
5. Select new build
6. Submit for review

**Subsequent reviews are often faster** (1-2 days).

---

## Troubleshooting

### Build Not Appearing

**Issue**: Build doesn't appear in App Store Connect after upload

**Solutions**:
- Wait 5-30 minutes for processing
- Check email for "processing complete" notification
- Verify upload succeeded (Xcode Organizer)
- Ensure correct Bundle ID

### Cannot Submit

**Issue**: "Submit for Review" button grayed out

**Solutions**:
- Ensure build is selected
- Fill in all required fields (red asterisks)
- Save changes
- Refresh page

### Export Compliance Issues

**Issue**: Confused about encryption questions

**Solution**: For Trek (using standard HTTPS only):
- Uses encryption: YES
- Exempt: YES (standard iOS encryption)
- Proprietary: NO

### Demo Account Not Working

**Issue**: Reviewer can't login

**Solutions**:
- Test demo account yourself before submission
- Verify credentials are correct in Review Notes
- Ensure account still exists in Firebase
- Check Firebase Auth is enabled

---

## Tips for Faster Approval

✅ **DO**:
- Provide detailed review notes
- Create demo account with sample data
- Test thoroughly before submission
- Respond quickly to reviewer questions
- Be clear about location usage

❌ **DON'T**:
- Submit with placeholder content
- Leave demo account empty
- Submit with crashes
- Be vague in review notes
- Ignore reviewer feedback

---

## Timeline

**Typical First Submission**:
- Upload build: 30 min
- Fill out metadata: 30-60 min
- **Submit**
- Waiting for Review: 1-3 days
- In Review: 8-24 hours
- **Approved** (or rejected)
- Manual release: Instant
- Live on App Store: 24 hours after release

**Total**: 3-7 days from submission to live

---

## Resources

- [App Store Connect](https://appstoreconnect.apple.com)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [App Review Status](https://developer.apple.com/app-store/review/)
- [Apple Developer Forums](https://developer.apple.com/forums/)

---

## Summary

**Submission Process**:
1. ✅ Complete all prerequisites
2. ✅ Login to App Store Connect
3. ✅ Fill in all metadata
4. ✅ Upload screenshots
5. ✅ Select build
6. ✅ Add review information
7. ✅ Submit for review
8. ⏱️ Wait for approval (1-7 days)
9. 🎉 Release to App Store!

**You're ready to submit Trek!** 🚀

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Time**: 30-45 minutes for submission process
