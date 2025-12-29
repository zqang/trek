# Trek App Icons Guide

**Created**: December 29, 2025

## Overview

This guide details the app icon requirements and design specifications for the Trek fitness tracking app.

## App Icon Sizes Required

### iOS App Icon Sizes

| Device/Context | Size (pt) | Size (px @3x) | Size (px @2x) | Filename |
|----------------|-----------|---------------|---------------|----------|
| iPhone App | 60x60 | 180x180 | 120x120 | Icon-60@3x.png, Icon-60@2x.png |
| iPad App | 76x76 | 228x228 | 152x152 | Icon-76@3x.png, Icon-76@2x.png |
| iPad Pro | 83.5x83.5 | - | 167x167 | Icon-83.5@2x.png |
| App Store | 1024x1024 | 1024x1024 | - | AppIcon-AppStore.png |
| Settings | 29x29 | 87x87 | 58x58 | Icon-29@3x.png, Icon-29@2x.png |
| Spotlight | 40x40 | 120x120 | 80x80 | Icon-40@3x.png, Icon-40@2x.png |
| Notification | 20x20 | 60x60 | 40x40 | Icon-20@3x.png, Icon-20@2x.png |

### Complete Size List (px)

**Required for submission**:
- 1024×1024 (App Store)
- 180×180 (iPhone @3x)
- 167×167 (iPad Pro @2x)
- 152×152 (iPad @2x)
- 120×120 (iPhone @2x, Spotlight @3x)
- 87×87 (Settings @3x)
- 80×80 (Spotlight @2x)
- 60×60 (Notification @3x)
- 58×58 (Settings @2x)
- 40×40 (Notification @2x)

## Design Specifications

### Brand Identity

**App Name**: Trek

**Primary Concept**: Mountain/Peak symbolizing fitness journey and progress

**Design Elements**:
- Mountain peak silhouette
- Upward arrow or path representing progress
- Activity tracking elements (route line, GPS pin)
- Clean, modern, recognizable

### Color Palette

**Primary Colors** (from Trek brand):
```
Primary Blue: #007AFF (iOS system blue)
Success Green: #34C759
Background: #F2F2F7 (light mode)
Dark Background: #1C1C1E (dark mode)
```

**Icon Colors**:
- Gradient from blue to green (representing journey/growth)
- Or solid primary blue with white symbol
- Must work on both light and dark backgrounds

### Design Guidelines

1. **Simplicity**: Icon must be recognizable at small sizes (20×20)
2. **No Text**: Don't include "Trek" text in the icon
3. **Centered Design**: Main symbol should be centered
4. **Padding**: Maintain ~10% padding from edges
5. **Contrast**: Must be visible on all backgrounds
6. **Consistency**: Should match app's visual identity

## Design Concepts

### Concept 1: Mountain Peak
```
┌─────────────────┐
│                 │
│       /\        │
│      /  \       │
│     /    \      │
│    /      \     │
│   /________\    │
│   └────────┘    │
│   Route Path    │
└─────────────────┘
```
- Blue/green gradient mountain
- Dotted route path at base
- Clean, minimalist

### Concept 2: GPS Pin + Mountain
```
┌─────────────────┐
│        📍       │
│       /  \      │
│      /    \     │
│     /  /\  \    │
│    /__/  \__\   │
│                 │
└─────────────────┘
```
- GPS pin marker on mountain peak
- Represents tracking + destination

### Concept 3: Activity Ring
```
┌─────────────────┐
│                 │
│      ╭───╮      │
│     │  /\ │     │
│     │ /  \│     │
│      ╰───╯      │
│    Activity     │
│     Circle      │
└─────────────────┘
```
- Mountain inside activity tracking ring
- Modern, activity-focused

### Concept 4: Route Path (Recommended)
```
┌─────────────────┐
│                 │
│     ╱╲  ╱╲      │
│    ╱  ╲╱  ╲     │
│   ╱    ╲   ╲    │
│  •──────────•   │
│  Start    End   │
└─────────────────┘
```
- Elevation profile with route path
- Start and end points
- Immediately conveys fitness tracking

## Asset Creation Steps

### Option 1: Using Design Tool (Recommended)

**Tools**:
- Figma (free, web-based)
- Sketch (Mac only, paid)
- Adobe Illustrator (paid)
- Affinity Designer (paid, one-time)

**Process**:
1. Create 1024×1024 canvas
2. Design icon with guidelines above
3. Export all required sizes
4. Use iOS icon template if available

### Option 2: Using Icon Generator Services

**Recommended Services**:
- **AppIconGenerator.net** (free)
- **MakeAppIcon.com** (free)
- **AppIcon.co** (free)

**Process**:
1. Create single 1024×1024 PNG
2. Upload to service
3. Download complete icon set
4. Add to Xcode project

### Option 3: AI Generation + Editing

**Tools**:
- Midjourney, DALL-E, or Stable Diffusion
- Then edit in Figma/Photoshop

**Prompt Example**:
```
"iOS app icon for fitness tracking app, mountain peak symbol,
blue gradient, minimalist, flat design, no text, centered,
professional, modern, clean"
```

## Adding Icons to Xcode

### Step 1: Prepare Asset Catalog

1. Open Xcode project
2. Navigate to `Trek/Trek/Assets.xcassets`
3. Select `AppIcon` asset

### Step 2: Add Icons

Drag and drop icon files to appropriate slots:

```
AppIcon.appiconset/
├── Icon-20@2x.png          (40×40)
├── Icon-20@3x.png          (60×60)
├── Icon-29@2x.png          (58×58)
├── Icon-29@3x.png          (87×87)
├── Icon-40@2x.png          (80×80)
├── Icon-40@3x.png          (120×120)
├── Icon-60@2x.png          (120×120)
├── Icon-60@3x.png          (180×180)
├── Icon-76@2x.png          (152×152)
├── Icon-83.5@2x.png        (167×167)
└── Icon-1024.png           (1024×1024)
```

### Step 3: Verify Configuration

Check `Contents.json` in AppIcon.appiconset:

```json
{
  "images" : [
    {
      "filename" : "Icon-20@2x.png",
      "idiom" : "iphone",
      "scale" : "2x",
      "size" : "20x20"
    },
    {
      "filename" : "Icon-20@3x.png",
      "idiom" : "iphone",
      "scale" : "3x",
      "size" : "20x20"
    },
    // ... (continue for all sizes)
    {
      "filename" : "Icon-1024.png",
      "idiom" : "ios-marketing",
      "scale" : "1x",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
```

## Icon Design Checklist

Before submitting to App Store:

- [ ] All required sizes present (1024×1024 through 40×40)
- [ ] PNG format with no transparency
- [ ] sRGB or P3 color space
- [ ] No alpha channel (fully opaque)
- [ ] Recognizable at smallest size (40×40)
- [ ] Works on both light and dark backgrounds
- [ ] Matches brand identity
- [ ] No rounded corners (iOS adds automatically)
- [ ] No text or words
- [ ] Professional and polished appearance
- [ ] Tested on actual device
- [ ] Follows Apple Human Interface Guidelines

## App Store Icon Requirements

The 1024×1024 App Store icon has specific requirements:

1. **Format**: PNG (no transparency)
2. **Color Space**: RGB (sRGB or Display P3)
3. **Layers**: Flattened (no layers)
4. **No Alpha**: Must be fully opaque
5. **No Rounded Corners**: Submit square image
6. **Professional Quality**: High resolution, no artifacts

## Testing Icons

### On Simulator
1. Build and run app in simulator
2. Go to Home Screen
3. Verify icon appears correctly
4. Test on different device sizes

### On Physical Device
1. Install via Xcode or TestFlight
2. Check Home Screen appearance
3. Test in Spotlight search
4. Check Settings app icon
5. Verify notification icon (send test notification)

### In Different Contexts
- [ ] Home Screen (light mode)
- [ ] Home Screen (dark mode)
- [ ] Spotlight search
- [ ] Settings app
- [ ] Notifications
- [ ] App Switcher
- [ ] Share sheet

## Icon Variations (Optional)

### Alternate Icons

iOS allows alternate icons for user customization:

```swift
// Trek/Trek/Assets.xcassets/
├── AppIcon (default)
├── AppIconDark (dark theme)
├── AppIconMinimal (minimal design)
└── AppIconPride (special edition)
```

**Implementation**:
```swift
// Add to SettingsView or ProfileView
if UIApplication.shared.supportsAlternateIcons {
    UIApplication.shared.setAlternateIconName("AppIconDark") { error in
        if let error = error {
            print("Error setting alternate icon: \(error)")
        }
    }
}
```

## Resources

### Design Guidelines
- [Apple Human Interface Guidelines - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [iOS App Icon Template](https://applypixels.com/template/ios-app-icon)

### Icon Generators
- [AppIconGenerator.net](https://appicongenerator.net)
- [MakeAppIcon.com](https://makeappicon.com)
- [AppIcon.co](https://appicon.co)

### Design Inspiration
- [Dribbble - iOS App Icons](https://dribbble.com/search/ios-app-icon)
- [Behance - Mobile App Icons](https://www.behance.net/search/projects?search=mobile%20app%20icon)

## Quick Start (For Development)

If you need a placeholder icon quickly:

1. Create a 1024×1024 image with Trek's primary color
2. Add a simple white mountain/peak symbol
3. Use AppIconGenerator.net to create all sizes
4. Add to Xcode Assets catalog
5. Replace with professional design before launch

## Next Steps

After completing app icons:

1. ✅ Create all required icon sizes
2. ✅ Add to Xcode Assets catalog
3. ✅ Test on simulator and device
4. ✅ Verify in all contexts
5. → Continue with Launch Screen design
6. → Create App Store screenshots

---

**Status**: Ready for icon design
**Priority**: High (required for App Store submission)
**Timeline**: 1-2 days for professional design

**Note**: This guide provides specifications and guidance. Actual icon design should be done by a designer or using the recommended tools/services above.
