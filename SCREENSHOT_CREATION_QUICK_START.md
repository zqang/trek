# Trek Screenshots - Quick Start Guide

**Created**: December 29, 2025

## Overview

Quick guide to create all 6 required App Store screenshots for Trek.

## Required Sizes

**Primary**: iPhone 6.7" (1290 × 2796 pixels)
- iPhone 14 Pro Max, 15 Pro Max, 15 Plus

**Also create** (Apple generates smaller from above, but good to have):
- iPhone 6.5" (1242 × 2688 pixels)

## 6 Required Screenshots

1. **Recording Screen** (Hero shot)
2. **Activity Summary**
3. **Activities List**
4. **Activity Detail**
5. **Profile & Statistics**
6. **Dark Mode** (optional but recommended)

---

## Quick Method (Recommended)

### Step 1: Run Trek on Simulator

```bash
# Open Xcode
open Trek.xcodeproj

# Select device: iPhone 15 Pro Max
# Product → Run (Cmd + R)
```

### Step 2: Create Sample Data

**In the app**:
1. Sign up/login with test account
2. Record 3-4 short activities:
   - "Morning Run" - 5.2 km, 30 min
   - "Afternoon Ride" - 15.3 km, 45 min
   - "Evening Walk" - 2.1 km, 25 min

**Quick recording**:
- Start → Wait 10 seconds → Pause → Move mouse to simulate GPS → Resume → Finish
- Or: Just walk around with your phone for 2-3 minutes per activity

### Step 3: Capture Screenshots

**Simulator Shortcuts**:
- **Cmd + S** → Save screenshot to Desktop
- File is automatically sized correctly (1290×2796)

**Capture these 6 screens**:

**Screenshot 1: Recording Screen**
1. Tab: Record
2. Start a new activity (Running)
3. Wait until stats show real data (distance > 0)
4. Cmd + S
5. Filename: `01-recording.png`

**Screenshot 2: Activity Summary**
1. Finish the recording
2. Activity Summary screen appears
3. Cmd + S
4. Filename: `02-summary.png`

**Screenshot 3: Activities List**
1. Tap "Save" to save the activity
2. Navigate to Activities tab
3. Scroll to show 3-4 activities
4. Cmd + S
5. Filename: `03-list.png`

**Screenshot 4: Activity Detail**
1. Tap on one activity to open details
2. Ensure map is visible
3. Cmd + S
4. Filename: `04-detail.png`

**Screenshot 5: Profile & Statistics**
1. Navigate to Profile tab
2. Cmd + S
3. Filename: `05-profile.png`

**Screenshot 6: Dark Mode**
1. iOS Settings → Developer → Dark Appearance: ON
2. Or: Simulator → Features → Toggle Appearance
3. Go to any screen (Recording or Activities work well)
4. Cmd + S
5. Filename: `06-dark-mode.png`

---

## Step 4: Add Annotations

**Option 1: Figma (Free & Recommended)**

1. Create Figma account (free)
2. Create new file: 1290×2796 frame
3. Import screenshot as background
4. Add text layers:
   - Title: 72pt, Bold, White, shadow
   - Subtitle: 48pt, Regular, White 90% opacity
5. Add gradient overlay at bottom (black, 60% opacity, height: 600px)
6. Position text over gradient
7. Export as PNG

**Example for Screenshot 1**:
```
Title: "Real-Time GPS Tracking"
Subtitle: "Track distance, pace, and elevation live"
```

**Option 2: Canva (Free)**

1. Go to canva.com
2. Create Custom Size: 1290 × 2796 px
3. Upload screenshot as background
4. Add text elements
5. Download as PNG

**Option 3: Keynote/PowerPoint (Quick & Easy)**

1. Create slide: Custom size 1290×2796
2. Insert screenshot as background
3. Add text boxes with:
   - Font: SF Pro Display (or Helvetica)
   - Title: 72pt, Bold, White
   - Shadow: 50% black, 4px offset
4. Export as image (PNG)

**Option 4: No Annotations (Acceptable)**

You can submit screenshots without text annotations. They should still look professional with:
- Good sample data (realistic activity names/stats)
- Clean UI with no placeholders
- Variety of screens shown

---

## Annotation Text Templates

### Screenshot 1: Recording
**Title**: "Real-Time GPS Tracking"
**Subtitle**: "Track distance, pace, and elevation live"

### Screenshot 2: Summary
**Title**: "Detailed Post-Workout Analysis"
**Subtitle**: "See your route, stats, and splits"

### Screenshot 3: List
**Title**: "Your Complete Activity History"
**Subtitle**: "Search, filter, and manage all workouts"

### Screenshot 4: Detail
**Title**: "Beautiful Route Visualization"
**Subtitle**: "See every detail of your journey"

### Screenshot 5: Profile
**Title**: "Track Your Progress"
**Subtitle**: "Lifetime statistics and achievements"

### Screenshot 6: Dark Mode
**Title**: "Beautiful in Light & Dark"
**Subtitle**: "Seamless dark mode support"

---

## Sample Data Tips

**For Realistic Screenshots**:

**Activity Names** (varied and interesting):
- "Morning Run"
- "Afternoon Ride"
- "Lunch Walk"
- "Weekend Hike"
- "Evening Run"

**Stats** (believable numbers):
- Runs: 3-10 km, 20-60 min
- Rides: 10-30 km, 30-90 min
- Walks: 1-5 km, 15-40 min
- Hikes: 5-15 km, 1-4 hours

**Profile Stats**:
- Total Activities: 20-50
- Total Distance: 100-300 km
- Total Duration: 15-30 hours

**Avoid**:
- Zero values (0:00, 0.00 km)
- Placeholder text ("Activity 1", "Test")
- Unrealistic numbers (999 km, 100 hours)

---

## Alternative: Real Device Screenshots

### Take Screenshots on iPhone

1. Build and run on your iPhone (Cmd + R with device selected)
2. Go to each screen
3. Take screenshot: **Volume Up + Side Button**
4. AirDrop to Mac or connect via cable
5. Photos → Select screenshots → Export

**Pros**:
- Most authentic
- Real device rendering

**Cons**:
- Need physical device
- Harder to get exact screenshots

---

## Creating iPad Screenshots (Optional)

If supporting iPad:

1. Run on iPad Pro 12.9" simulator
2. Same process as iPhone
3. Size: 2048 × 2732 pixels
4. Same 6 screenshots
5. Upload separately in App Store Connect

---

## Quality Checklist

Before uploading to App Store Connect:

- [ ] Correct resolution (1290×2796 for iPhone 6.7")
- [ ] PNG format (not JPEG)
- [ ] No simulator status bar (or acceptable status bar)
- [ ] Sample data is realistic
- [ ] No "Lorem Ipsum" or placeholders
- [ ] UI looks polished
- [ ] Maps show actual routes (not blank)
- [ ] Text annotations are readable (if added)
- [ ] All 6 screenshots prepared
- [ ] Screenshots tell a story (good order)
- [ ] File names are organized (01-, 02-, etc.)

---

## Upload to App Store Connect

1. Log in to [App Store Connect](https://appstoreconnect.apple.com)
2. Go to your app → Version → App Store Screenshots
3. Select device: **iPhone 6.7" Display**
4. Drag and drop screenshots in order:
   - Screenshot 1: Recording (this shows first!)
   - Screenshot 2: Summary
   - Screenshot 3: List
   - Screenshot 4: Detail
   - Screenshot 5: Profile
   - Screenshot 6: Dark Mode
5. Preview how they appear
6. Save

**Order matters!** First screenshot is most important.

---

## Advanced: Fastlane Snapshot (Automation)

For automated screenshot generation:

### Install Fastlane

```bash
sudo gem install fastlane
```

### Initialize

```bash
cd /path/to/trek
fastlane snapshot init
```

### Configure Snapfile

```ruby
# Snapfile
devices([
  "iPhone 15 Pro Max",
  "iPhone 14 Pro Max"
])

languages([
  "en-US"
])

scheme("Trek")

output_directory("./screenshots")

clear_previous_screenshots(true)
```

### Create UI Tests

Create `TrekUITests/ScreenshotTests.swift`:

```swift
import XCTest

class ScreenshotTests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        setupSnapshot(app)
        app.launch()
    }

    func testTakeScreenshots() {
        // Screenshot 1: Recording
        app.tabBars.buttons["Record"].tap()
        snapshot("01-recording")

        // Screenshot 2: Activities
        app.tabBars.buttons["Activities"].tap()
        snapshot("03-list")

        // Screenshot 3: Profile
        app.tabBars.buttons["Profile"].tap()
        snapshot("05-profile")

        // Add more screenshots...
    }
}
```

### Run Snapshot

```bash
fastlane snapshot
```

Screenshots generated automatically!

**Note**: Requires UI Test target and more setup. Manual method is faster for first release.

---

## Localization (Future)

When adding languages:

- Create separate screenshot sets for each language
- Translate annotation text
- UI text automatically localizes
- Same 6 screenshots per language

**Languages to consider**:
- Spanish (es-ES)
- French (fr-FR)
- German (de-DE)
- Chinese Simplified (zh-Hans)

---

## Quick Start Summary

**Fastest Method (30 minutes)**:

1. Run Trek on iPhone 15 Pro Max simulator
2. Create 3-4 sample activities
3. Take 6 screenshots (Cmd + S)
4. (Optional) Add annotations in Figma/Canva
5. Upload to App Store Connect
6. ✅ Done!

**Files you'll have**:
```
screenshots/
├── 01-recording.png (1290×2796)
├── 02-summary.png
├── 03-list.png
├── 04-detail.png
├── 05-profile.png
└── 06-dark-mode.png
```

---

## Troubleshooting

**Issue**: Simulator screenshot is wrong size
- **Solution**: Ensure iPhone 15 Pro Max is selected (not iPhone 14 or smaller)
- **Solution**: Check screenshot file properties (should be 1290×2796)

**Issue**: Screenshots look blurry
- **Solution**: Don't scale up images - use exact simulator output
- **Solution**: Ensure "Scale" is 100% in simulator

**Issue**: Can't get good sample data
- **Solution**: Record actual short activities (walk 2-3 min)
- **Solution**: Or manually create activities in Firestore Console

**Issue**: Map is blank in screenshots
- **Solution**: Ensure location permission granted in simulator
- **Solution**: Simulate location: Features → Location → Custom
- **Solution**: Or use real GPS data from device

---

## Resources

- [Apple Screenshot Guidelines](https://developer.apple.com/app-store/product-page/)
- [Screenshot Best Practices](https://www.appmysite.com/blog/app-store-screenshots/)
- Figma: figma.com
- Canva: canva.com

---

**Screenshots are your #1 conversion tool. Invest time to make them great!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Time**: 30 minutes - 2 hours
