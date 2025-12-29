# Demo Account Setup for App Review

**Created**: December 29, 2025

## Overview

Create a demo account for Apple App Review to test Trek during the review process.

## Why You Need This

Apple reviewers need to:
- Sign in without creating an account
- Test all features immediately
- Verify your app works as described

Providing a demo account **speeds up review** and prevents rejection.

---

## Quick Setup (10 minutes)

### Step 1: Create Demo Account

**Option 1: In Trek App** (Recommended)

1. Run Trek on simulator or device
2. Tap "Sign Up"
3. Email: `reviewer@trekapp.com`
4. Password: `ReviewTrek2025!`
5. Complete signup
6. Skip profile photo (optional)

**Option 2: Firebase Console**

1. Firebase Console → Authentication
2. Add User
3. Email: `reviewer@trekapp.com`
4. Password: `ReviewTrek2025!`
5. Click Add

### Step 2: Add Sample Activities

**Create 3-5 varied activities** so reviewer sees a populated app:

**Activity 1: Morning Run**
- Record a 5-10 minute walk/run
- Or create manually in Firestore Console

**Activity 2: Afternoon Ride**
- Different activity type
- Longer duration (15-20 min)

**Activity 3: Evening Walk**
- Shorter activity (5 min)

**Quick Method** (if short on time):
1. Record 3 short activities (2-3 min each)
2. Change types: Run, Ride, Walk
3. Edit names to be descriptive

### Step 3: Document Credentials

**For App Store Connect** → App Review Information:

```
Demo Account Credentials:

Email: reviewer@trekapp.com
Password: ReviewTrek2025!

Notes:
- Account has 3-5 sample activities pre-loaded
- Location permission will be requested on first use
- Full functionality available
```

---

## Manual Activity Creation (Firebase Console)

If you want perfect sample data:

### Access Firestore

1. Firebase Console → Firestore Database
2. Start collection: `activities`
3. Add document

### Sample Activity Document

```json
{
  "userId": "[reviewer_user_id]",
  "name": "Morning Run",
  "type": "run",
  "startTime": "2025-01-15T06:30:00Z",
  "endTime": "2025-01-15T07:00:00Z",
  "distance": 5200,
  "duration": 1800,
  "elevationGain": 45,
  "route": [
    {
      "latitude": 37.33182,
      "longitude": -122.03118,
      "timestamp": "2025-01-15T06:30:00Z",
      "altitude": 50,
      "accuracy": 5
    },
    // ... more points
  ],
  "splits": [
    {
      "distance": 1000,
      "duration": 360,
      "pace": 6.0
    },
    // ... more splits
  ],
  "isPrivate": false,
  "createdAt": "2025-01-15T07:01:00Z"
}
```

**Note**: Replace `[reviewer_user_id]` with the actual UID from Authentication.

---

## Best Practices

### Demo Account Guidelines

**DO**:
- ✅ Use simple, memorable credentials
- ✅ Add 3-5 sample activities
- ✅ Use realistic activity names
- ✅ Include different activity types
- ✅ Make account permanent (don't delete)
- ✅ Test login before submission

**DON'T**:
- ❌ Use your personal account
- ❌ Use complex password (reviewer types on iOS)
- ❌ Leave account empty
- ❌ Use Lorem Ipsum or test data
- ❌ Require additional steps to test

### Sample Activities Checklist

- [ ] At least 3 activities created
- [ ] Mix of activity types (Run, Ride, Walk)
- [ ] Realistic names ("Morning Run", not "Test 1")
- [ ] Varied stats (different distances/times)
- [ ] Routes with GPS data (not empty)
- [ ] Activities saved successfully
- [ ] Visible in app when logged in

### Testing Demo Account

**Before submission, verify**:
1. Log out of your account in Trek
2. Log in with demo credentials
3. Verify:
   - [ ] Login succeeds
   - [ ] Activities appear in list
   - [ ] Can view activity details
   - [ ] Can record new activity
   - [ ] Can edit activity
   - [ ] Profile shows stats
   - [ ] Settings work
   - [ ] Can export data

---

## Alternative: Sign In with Apple

If you're using Apple Sign In:

### Option 1: Demo Account Still Recommended

Create email/password demo account even if you support Apple Sign In:
- Easier for reviewer
- No Apple ID required
- Faster review process

### Option 2: Apple Sign In Only

If you MUST use only Apple Sign In:

**In App Review Information**:
```
This app requires Apple Sign In.

Reviewers can create an account using their Apple ID.
No demo account required.

Instructions:
1. Tap "Sign in with Apple"
2. Use reviewer's Apple ID
3. Account will be created automatically
```

**Note**: This may slow down review if reviewer has issues.

---

## App Review Information (Complete Form)

**In App Store Connect** → App Information → App Review Information:

### Contact Information
```
First Name: [Your First Name]
Last Name: [Your Last Name]
Phone Number: [Your Phone]
Email: support@trekapp.com
```

### Demo Account (if applicable)
```
Username: reviewer@trekapp.com
Password: ReviewTrek2025!
```

### Notes
```
DEMO ACCOUNT INFO:
Email: reviewer@trekapp.com
Password: ReviewTrek2025!

The demo account has 3-5 sample activities pre-loaded.

HOW TO TEST:
1. Launch Trek
2. Tap "Login" (not Sign Up)
3. Enter demo credentials above
4. Grant location permission when prompted
5. Navigate to "Activities" tab to see sample workouts
6. Tap "Record" to test activity tracking
7. Walk around briefly to generate GPS data
8. Tap "Finish" to complete recording

LOCATION PERMISSION:
The app requires location permission ("While Using the App") to record GPS coordinates during activities. This is ONLY used when actively recording. There is no background tracking except during active recording sessions.

FIREBASE SERVICES:
The app uses Firebase for:
- Authentication (Firebase Auth)
- Data storage (Cloud Firestore)
- Profile photos (Cloud Storage)
- Analytics and crash reporting

All features are accessible with the demo account.

Contact support@trekapp.com with any questions.

Thank you!
```

---

## Security Considerations

### Password Security

**Demo Password**: `ReviewTrek2025!`
- Not your real password
- Public (Apple reviewers see it)
- Change after review if concerned

### Account Permissions

Demo account should have:
- ✅ Standard user permissions
- ❌ No admin access
- ❌ No ability to delete other users
- ❌ No sensitive data visible

### Post-Review

**After approval**:
- Keep demo account active (for updates)
- Or delete and create new for next version
- Don't reuse for real users

---

## Troubleshooting

### Reviewer Can't Login

**Possible Issues**:
- Wrong credentials (typo in notes)
- Account deleted accidentally
- Firebase Auth disabled
- Email/Password provider not enabled

**Prevention**:
- Test demo account before submission
- Screenshot successful login
- Keep credentials simple

### Reviewer Says "No Data"

**Possible Issues**:
- Activities not synced to Firestore
- Wrong userId in activity documents
- Firestore security rules blocking access

**Prevention**:
- Test demo account thoroughly
- Verify activities appear when logged in
- Check Firestore Console shows activities

### Location Permission Issues

**Possible Issues**:
- Reviewer doesn't grant permission
- Permission prompt not clear

**Prevention**:
- Explain location usage in Review Notes
- Add NSLocationWhenInUseUsageDescription to Info.plist
- Make permission prompt clear in app

---

## Quick Start Checklist

Before submission:

**Demo Account**:
- [ ] Created: `reviewer@trekapp.com`
- [ ] Password: `ReviewTrek2025!`
- [ ] Can login successfully
- [ ] 3-5 sample activities added
- [ ] Activities visible in app
- [ ] Tested all features work

**App Review Information**:
- [ ] Contact info filled out
- [ ] Demo account credentials entered
- [ ] Detailed testing notes provided
- [ ] Location permission explained
- [ ] Firebase services disclosed

**Final Test**:
- [ ] Log out of personal account
- [ ] Log in with demo account
- [ ] Verify everything works
- [ ] Ready for submission ✅

---

## Sample Activities Reference

**Good Examples**:
- "Morning Run - 5.2 km - 30:00"
- "Afternoon Bike Ride - 15.3 km - 45:18"
- "Evening Walk - 2.1 km - 25:45"
- "Weekend Hike - 8.7 km - 2:15:30"

**Bad Examples** (Don't use):
- "Test Activity"
- "Activity 1"
- "asdfgh"
- "123456"

---

## Post-Approval

### Keep or Delete?

**Keep** if:
- Planning frequent updates
- Want consistent review account
- Low security risk

**Delete** if:
- Concerned about public password
- Want fresh start for v1.1
- Account has sensitive test data

### Creating New Demo Account (Future)

For v1.1, v1.2, etc.:
1. Create new account or reuse existing
2. Update credentials in App Review Information
3. Add new sample activities (optional)
4. Test before resubmission

---

## Summary

**10-Minute Setup**:
1. Create `reviewer@trekapp.com` account
2. Add 3 sample activities (record quickly or create in Firestore)
3. Test login and verify activities appear
4. Add credentials to App Store Connect
5. ✅ Ready for review!

**Demo account speeds up approval and prevents rejection!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Time**: 10-15 minutes
