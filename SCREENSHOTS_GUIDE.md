# App Store Screenshots Guide

**Created**: December 29, 2025

## Overview

This guide provides detailed instructions for creating professional App Store screenshots for Trek. Screenshots are crucial for conversion rates—they're often the first impression users have of your app.

## Screenshot Requirements

### Device Sizes Required

**iPhone 6.7" Display** (Primary - Required)
- Devices: iPhone 14 Pro Max, 15 Pro Max, 15 Plus
- Resolution: 1290 × 2796 pixels (portrait)
- Scale: @3x
- **Priority**: HIGH - This is the primary size

**iPhone 6.5" Display** (Secondary - Required)
- Devices: iPhone 11 Pro Max, XS Max, 11, XR
- Resolution: 1242 × 2688 pixels (portrait)
- Scale: @3x
- **Priority**: MEDIUM - Apple generates smaller sizes from this

**iPad Pro 12.9" Display** (Optional but Recommended)
- Devices: iPad Pro 12.9" (3rd, 4th, 5th, 6th gen)
- Resolution: 2048 × 2732 pixels (portrait)
- Scale: @2x
- **Priority**: MEDIUM - iPad support

### Format Specifications

- **Format**: PNG or JPG (PNG preferred for quality)
- **Color Space**: sRGB or Display P3
- **Orientation**: Portrait (vertical)
- **Count**: 3-10 screenshots (recommend 5-6)
- **File Size**: Max 500 MB per screenshot (typically 1-5 MB)

## Recommended Screenshots

### Screenshot Set (6 screens)

1. **Recording Screen** - Hero shot showing live activity tracking
2. **Activity Summary** - Post-workout statistics and map
3. **Activities List** - Beautiful activity feed
4. **Activity Detail** - Full-screen route map with details
5. **Profile & Statistics** - Lifetime stats and achievements
6. **Dark Mode** (Optional) - Show Trek in dark mode

## Screenshot Content Guide

### 1. Recording Screen (Hero Shot)

**Purpose**: Show the app in action during a workout

**Content**:
- Active recording interface
- Real-time stats displaying
- Small map preview at top
- Activity type selected (Running)
- GPS signal indicator showing "Excellent"
- Live metrics: Distance, Duration, Pace, Elevation

**Sample Data**:
```
Distance: 5.32 km
Duration: 32:18
Current Pace: 6:04 min/km
Current Speed: 9.9 km/h
Elevation: +87 m
```

**Key Elements**:
- Green "Recording" indicator pulsing
- Route visible on mini map
- Finish button prominent
- Professional, in-use appearance

**Annotation Text** (overlay):
```
"Real-Time GPS Tracking"
"Track distance, pace, and elevation live"
```

### 2. Activity Summary

**Purpose**: Show detailed post-workout view

**Content**:
- Large route map at top
- 6-card statistics grid
- Splits table (3-4 splits visible)
- "Save Activity" button
- Activity type: Running

**Sample Data**:
```
Activity: Morning Run
Distance: 10.2 km
Duration: 58:42
Avg Pace: 5:45 min/km
Elevation Gain: 124 m
Calories: 672 kcal
```

**Key Elements**:
- Beautiful route visualization
- Clear, readable statistics
- Professional card design
- Share and save options

**Annotation Text**:
```
"Detailed Post-Workout Analysis"
"See your route, stats, and splits"
```

### 3. Activities List

**Purpose**: Show activity management and history

**Content**:
- 3-4 activity cards visible
- Search bar at top
- Filter and sort options
- Mix of activity types (Run, Ride, Walk)
- Each card shows mini map preview

**Sample Activities**:
```
1. Evening Ride - 15.3 km - 42:18
2. Morning Run - 8.2 km - 45:12
3. Weekend Hike - 12.5 km - 3:24:18
```

**Key Elements**:
- Beautiful mini map thumbnails
- Clear activity information
- Easy-to-scan layout
- Search and filter visible

**Annotation Text**:
```
"Your Complete Activity History"
"Search, filter, and manage all workouts"
```

### 4. Activity Detail

**Purpose**: Show full activity details and map

**Content**:
- Large, full-screen route map
- Route line clearly visible
- Start (green) and end (checkered) markers
- Statistics below map
- Edit and share buttons

**Sample Data**:
```
Morning Run
10.5 km • 58:30 • 5:34 min/km
Jan 15, 2025 at 6:30 AM

Stats:
Distance: 10.5 km
Duration: 58:30
Pace: 5:34 min/km
Elevation: +145 m
```

**Key Elements**:
- Beautiful map visualization
- Clear route path
- Easy-to-read details
- Export GPX option visible

**Annotation Text**:
```
"Beautiful Route Visualization"
"See every detail of your journey"
```

### 5. Profile & Statistics

**Purpose**: Show user progress and lifetime stats

**Content**:
- Profile header with user info
- Total statistics cards (4 cards):
  - Total Distance: 247.3 km
  - Total Activities: 42
  - Total Duration: 28h 15m
  - Elevation Gain: 3,247 m
- Activity breakdown chart
- Recent achievements

**Key Elements**:
- Clean, organized layout
- Impressive cumulative stats
- Visual progress indicators
- Settings and export options

**Annotation Text**:
```
"Track Your Progress"
"Lifetime statistics and achievements"
```

### 6. Dark Mode (Optional)

**Purpose**: Show Trek works beautifully in dark mode

**Content**:
- Any of the above screens in dark mode
- Recording screen works well
- Or Activities List in dark mode

**Key Elements**:
- Beautiful dark color scheme
- Readable text and contrast
- Maps work well in dark mode
- Professional appearance

**Annotation Text**:
```
"Beautiful in Light & Dark"
"Seamless dark mode support"
```

## Screenshot Annotations

### Text Overlay Guidelines

**Title Text**:
- Font: SF Pro Display Bold or similar
- Size: 60-80 pt (for 1290px wide screens)
- Color: White with shadow, or contrasting color
- Position: Top or bottom third
- Max: 1-2 lines

**Subtitle Text**:
- Font: SF Pro Text Regular or similar
- Size: 40-50 pt
- Color: Same as title but slightly transparent
- Max: 1 line

**Placement**:
- Don't cover important UI elements
- Use gradient overlays for readability
- Ensure text contrasts with background

### Example Layout
```
┌──────────────────────────┐
│                          │
│  [Screenshot Content]    │
│                          │
│  "Feature Title"         │ ← Title (bold, large)
│  "Brief description"     │ ← Subtitle (regular, smaller)
│                          │
└──────────────────────────┘
```

## Creating Screenshots

### Method 1: Device Screenshots (Recommended)

**Steps**:
1. Build and run Trek on target device (iPhone 15 Pro Max)
2. Navigate to the screen you want to capture
3. Add sample data if needed
4. Press Volume Up + Side button to screenshot
5. Transfer to Mac via AirDrop
6. Add annotations in design tool

**Advantages**:
- Real device rendering
- Authentic appearance
- Accurate colors and fonts

### Method 2: Simulator Screenshots

**Steps**:
1. Run Trek on Xcode Simulator (iPhone 15 Pro Max)
2. Add sample activities for realistic data
3. Navigate to screen
4. Cmd + S to save screenshot (saves to Desktop)
5. Add annotations

**Advantages**:
- Faster iteration
- No device needed
- Easy to reproduce

**Note**: Simulator screenshots are at actual pixel dimensions (1290×2796)

### Method 3: Fastlane Snapshot (Advanced)

For automated screenshot generation:

```ruby
# Fastfile
lane :screenshots do
  snapshot(
    scheme: "Trek",
    devices: ["iPhone 15 Pro Max", "iPhone 11 Pro Max", "iPad Pro (12.9-inch)"],
    languages: ["en-US"],
    output_directory: "./screenshots",
    clear_previous_screenshots: true
  )
end
```

## Adding Annotations

### Design Tools

**Option 1: Figma (Recommended - Free)**
1. Import screenshot
2. Add text layers
3. Add gradient overlays
4. Export as PNG

**Option 2: Sketch (Mac, Paid)**
1. Create artboard at exact size
2. Import screenshot
3. Add text and graphics
4. Export at @1x

**Option 3: Photoshop (Paid)**
1. Create document at screenshot size
2. Import screenshot as layer
3. Add text layers with styles
4. Export as PNG

**Option 4: Canva (Free/Paid)**
1. Create custom size (1290×2796)
2. Upload screenshot as background
3. Add text elements
4. Download as PNG

### Quick Annotation Template

For consistent branding:

**Text Style**:
- Title: SF Pro Display Bold, 72pt, White, 50% black shadow
- Subtitle: SF Pro Text Regular, 48pt, White 90% opacity
- Background: Linear gradient from transparent to black 60% opacity

**Positioning**:
- Text at bottom: 200px from bottom
- Gradient overlay: bottom 600px

## Sample Data Guidelines

### For Recording Screen
- Show realistic mid-workout data (not 0:00)
- GPS signal should be "Good" or "Excellent"
- Route should have visible path on map
- Use round numbers for clarity (5.00 km, not 5.0234 km)

### For Activity Cards
Use varied, realistic data:

```
Activities:
1. "Morning Run" - 10.2 km - 58:42 - Running
2. "Afternoon Ride" - 32.5 km - 1:24:18 - Cycling
3. "Lunch Walk" - 2.3 km - 28:15 - Walking
4. "Mountain Hike" - 8.7 km - 2:45:30 - Hiking
```

### For Statistics
Show impressive but believable cumulative stats:

```
Total Distance: 247 km
Total Activities: 42
Total Duration: 28h 15m
Total Elevation: 3,247 m
```

## Screenshot Checklist

Before uploading to App Store Connect:

### Content Quality
- [ ] All screenshots use real Trek app UI
- [ ] Sample data is realistic and professional
- [ ] No Lorem Ipsum or placeholder text
- [ ] GPS routes look authentic
- [ ] Statistics are believable

### Technical Quality
- [ ] Correct resolution (1290×2796 for iPhone 6.7")
- [ ] PNG format with no compression artifacts
- [ ] File size under 500 MB (typically 2-5 MB)
- [ ] No device frames (just app UI)
- [ ] No rounded corners (App Store adds them)

### Annotations
- [ ] Text is readable and professional
- [ ] Text doesn't cover critical UI
- [ ] Consistent styling across all screenshots
- [ ] No typos or grammatical errors
- [ ] Follows brand guidelines

### Set Completeness
- [ ] 5-6 screenshots prepared
- [ ] Screenshots tell a story (flow makes sense)
- [ ] Hero shot is first
- [ ] Shows key features
- [ ] Includes dark mode example (optional)

### Device Sizes
- [ ] iPhone 6.7" screenshots (primary)
- [ ] iPhone 6.5" screenshots (if creating manually)
- [ ] iPad screenshots (if supporting iPad)

## Best Practices

### Do's
✅ Use real app interface
✅ Show features in action
✅ Use high-quality sample data
✅ Tell a story with screenshot sequence
✅ Show diverse activity types
✅ Include both light and dark mode
✅ Keep text minimal and impactful
✅ Ensure UI elements are visible
✅ Use consistent branding

### Don'ts
❌ Don't use device mockups (App Store adds frames)
❌ Don't include status bar with real time/battery
❌ Don't use placeholder or dummy data
❌ Don't cover important UI with text
❌ Don't make text too small to read
❌ Don't use more than 2 lines of text
❌ Don't include offensive or inappropriate content
❌ Don't use misleading screenshots

## Screenshot Flow

Recommended order for telling your app's story:

```
1. Recording Screen (Hero)
   ↓
   "This is Trek in action"

2. Activity Summary
   ↓
   "See detailed results"

3. Activities List
   ↓
   "Track all your workouts"

4. Activity Detail
   ↓
   "Beautiful route visualization"

5. Profile Stats
   ↓
   "Monitor your progress"

6. Dark Mode
   ↓
   "Beautiful day and night"
```

## Localization (Future)

When localizing:
- Create separate screenshot sets for each language
- Translate annotation text
- UI text will automatically localize
- Same device sizes required for each language

## Resources

### Sample Data Generator

Create a test user account with sample activities:

```swift
// In Firebase Console or via script
// Add 8-10 sample activities with varied:
// - Activity types
// - Distances (2-30 km range)
// - Durations (15 min - 3 hours)
// - Routes (different areas)
```

### Screenshot Tools

**Free**:
- Figma (figma.com)
- Canva (canva.com)
- GIMP (gimp.org)

**Paid**:
- Sketch (sketch.com)
- Adobe Photoshop (adobe.com)
- Affinity Designer (affinity.serif.com)

**Automation**:
- Fastlane Snapshot (fastlane.tools)
- AppLaunchpad (applaunchpad.com)

## Testing Before Upload

### Preview on Device
1. Transfer screenshot to iPhone
2. View in Photos app at full screen
3. Verify text is readable
4. Check for any issues

### A/B Testing Plan (Post-Launch)
After launch, test variations:
- Different screenshot orders
- Alternative annotation text
- With/without text overlays
- Light vs dark mode prominence

Monitor conversion rate (views → downloads) in App Store Connect Analytics.

## Upload to App Store Connect

### Steps
1. Log in to App Store Connect
2. Navigate to your app → Version → App Store Screenshots
3. Select device size (iPhone 6.7" Display)
4. Drag and drop screenshots in order
5. Repeat for other device sizes
6. Preview how they appear
7. Save changes

### Order Matters
Screenshots appear in the order you upload them. First screenshot is most important—it's the only one visible before users tap to expand.

---

## Quick Start Guide

**To create your screenshot set quickly**:

1. **Run Trek on iPhone 15 Pro Max simulator**
2. **Create sample activities** (add 3-4 varied activities)
3. **Capture 6 screens**:
   - Recording (tap Record → Start → simulate briefly)
   - Summary (finish an activity)
   - List (go to Activities tab)
   - Detail (tap an activity)
   - Profile (go to Profile tab)
   - Dark mode (enable in iOS Settings)
4. **Add annotations in Figma**:
   - Import screenshots
   - Add title + subtitle text
   - Add subtle gradient overlays
   - Export as PNG
5. **Upload to App Store Connect**

**Estimated time**: 2-3 hours for complete set

---

**Screenshots are your #1 conversion tool—invest time to make them great!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Target Devices**: iPhone 6.7", 6.5", iPad Pro 12.9"
