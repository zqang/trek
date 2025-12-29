# Trek App Icon - Quick Start Guide

**Created**: December 29, 2025

## Overview

This guide helps you create all required app icon sizes for Trek quickly and easily.

## Option 1: Use the SVG Template (Recommended)

### Step 1: Get the Template

The template is at: `design/icon-template.svg`

**Design**: Mountain peaks with route path
**Colors**: Blue to green gradient (#007AFF to #34C759)
**Size**: 1024×1024 (ready for App Store)

### Step 2: Customize (Optional)

Edit `icon-template.svg` in:
- **Figma**: File → Import → icon-template.svg
- **Adobe Illustrator**: File → Open
- **Inkscape** (free): File → Open
- **Online**: SVG-Edit.net

**Customizations**:
- Change gradient colors
- Adjust mountain shapes
- Modify route path
- Add/remove elements

### Step 3: Export 1024×1024 PNG

**Figma**:
1. Select artboard
2. Export → PNG → 1x → Export

**Illustrator**:
1. File → Export → Export As
2. Format: PNG
3. Resolution: 72 PPI (but size 1024×1024)

**Inkscape**:
1. File → Export PNG Image
2. Image size: 1024 × 1024
3. Export

**Online (CloudConvert)**:
1. Go to cloudconvert.com/svg-to-png
2. Upload icon-template.svg
3. Set width: 1024, height: 1024
4. Convert and download

### Step 4: Generate All Sizes

**Method 1: Online Generator (Easiest)**

1. Go to [AppIconGenerator.net](https://appicongenerator.net)
2. Upload your 1024×1024 PNG
3. Click "Generate"
4. Download ZIP file
5. Unzip to get all icon sizes

**Method 2: MakeAppIcon.com**

1. Go to [MakeAppIcon.com](https://makeappicon.com)
2. Upload 1024×1024 PNG
3. Download icon set
4. Extract iOS icons

**Method 3: Command Line (macOS)**

```bash
# Install ImageMagick
brew install imagemagick

# Create all sizes
cd /path/to/trek/design

# Function to generate icon
generate_icon() {
  size=$1
  scale=$2
  name=$3
  magick icon-1024.png -resize ${size}x${size} AppIcon-${name}@${scale}x.png
}

# Generate all required sizes
generate_icon 40 2 "20"    # 40×40 (20pt @2x)
generate_icon 60 3 "20"    # 60×60 (20pt @3x)
generate_icon 58 2 "29"    # 58×58 (29pt @2x)
generate_icon 87 3 "29"    # 87×87 (29pt @3x)
generate_icon 80 2 "40"    # 80×80 (40pt @2x)
generate_icon 120 3 "40"   # 120×120 (40pt @3x)
generate_icon 120 2 "60"   # 120×120 (60pt @2x)
generate_icon 180 3 "60"   # 180×180 (60pt @3x)
generate_icon 152 2 "76"   # 152×152 (76pt @2x)
generate_icon 167 2 "83.5" # 167×167 (83.5pt @2x)

# App Store
cp icon-1024.png AppIcon-AppStore.png
```

### Step 5: Add to Xcode

1. Open Xcode → Trek project
2. Navigate to `Trek/Trek/Assets.xcassets/AppIcon.appiconset`
3. Drag and drop each icon to appropriate slot:
   - 40×40 → iPhone Notification @2x
   - 60×60 → iPhone Notification @3x
   - 58×58 → iPhone Settings @2x
   - 87×87 → iPhone Settings @3x
   - 80×80 → iPhone Spotlight @2x
   - 120×120 → iPhone Spotlight @3x (also iPhone App @2x)
   - 180×180 → iPhone App @3x
   - 152×152 → iPad App @2x
   - 167×167 → iPad Pro App @2x
   - 1024×1024 → App Store

4. Build and run to test

---

## Option 2: Design From Scratch

### Recommended Tools

**Free**:
- Figma (figma.com) - web-based, professional
- Inkscape (inkscape.org) - desktop, open-source
- GIMP (gimp.org) - image editor

**Paid**:
- Adobe Illustrator - vector graphics
- Sketch (Mac only) - UI design
- Affinity Designer - one-time purchase

### Design Guidelines

**Size**: Start with 1024×1024
**Format**: PNG with no transparency
**Color**: sRGB color space
**Corners**: Square (iOS adds rounded corners automatically)

**Design Rules**:
- Simple and recognizable at small sizes (40×40)
- No text (especially not "Trek")
- Centered design with ~10% padding
- Works on both light and dark backgrounds
- Professional and polished

**Trek Brand**:
- Primary Color: #007AFF (iOS blue)
- Secondary: #34C759 (green)
- Concept: Mountain/peak representing journey and progress
- Style: Modern, clean, minimalist

### Design Process

1. **Create 1024×1024 canvas**
2. **Add background**: Blue gradient or solid color
3. **Add icon symbol**: Mountain, route path, or GPS pin
4. **Test at small sizes**: Scale to 40×40 to verify readability
5. **Export PNG** (no transparency)
6. **Generate all sizes** (use online generator)

---

## Option 3: AI Generation

### Midjourney Prompt

```
iOS app icon for fitness tracking app, mountain peak symbol,
blue to green gradient, minimalist flat design, no text,
centered composition, professional, modern, clean,
1024x1024, PNG --v 6 --ar 1:1
```

### DALL-E Prompt

```
A minimalist iOS app icon design for a fitness tracking app.
Features a stylized mountain peak in white on a blue-green gradient background.
Clean, modern, professional. No text. Centered. Square format.
Simple geometric shapes. Flat design style.
```

### After AI Generation

1. Download image
2. Resize to exactly 1024×1024 if needed
3. Use icon generator to create all sizes
4. Add to Xcode

---

## Icon Size Reference

| Usage | Size (pt) | @2x | @3x |
|-------|-----------|-----|-----|
| Notification | 20×20 | 40×40 | 60×60 |
| Settings | 29×29 | 58×58 | 87×87 |
| Spotlight | 40×40 | 80×80 | 120×120 |
| App (iPhone) | 60×60 | 120×120 | 180×180 |
| App (iPad) | 76×76 | 152×152 | - |
| App (iPad Pro) | 83.5×83.5 | 167×167 | - |
| App Store | 1024×1024 | - | - |

---

## Verification Checklist

Before submission:

- [ ] 1024×1024 PNG created
- [ ] All sizes generated (11 files)
- [ ] Icons added to Xcode AppIcon.appiconset
- [ ] No transparency (fully opaque)
- [ ] sRGB color space
- [ ] Recognizable at 40×40 size
- [ ] Works on light and dark backgrounds
- [ ] No rounded corners (Xcode handles this)
- [ ] Build succeeds
- [ ] Icon appears on simulator/device Home Screen
- [ ] Icon looks professional

---

## Testing Your Icon

1. **Simulator**: Build and run, check Home Screen
2. **Device**: Install on iPhone, verify appearance
3. **All Sizes**:
   - Home Screen (large)
   - Spotlight search (medium)
   - Settings (small)
   - Notifications (smallest)
4. **Contexts**:
   - Light mode
   - Dark mode
   - App Switcher
   - Share sheet

---

## Quick Start (30 Minutes)

**If you're in a hurry**:

1. Use provided SVG template
2. Export to 1024×1024 PNG (any tool)
3. Upload to AppIconGenerator.net
4. Download all sizes
5. Drag to Xcode AppIcon.appiconset
6. Done! ✅

**Or even faster**:

1. Use Figma App Icon Template (search "iOS app icon template Figma")
2. Customize colors/shapes
3. Export
4. Generate sizes
5. Add to Xcode

---

## Alternative: Placeholder Icon

For development/testing only (NOT for App Store):

1. Create solid blue square (1024×1024)
2. Add white "T" in center
3. Generate sizes
4. Use temporarily until final icon ready

**DO NOT submit placeholder to App Store!**

---

## Resources

### Icon Generators
- AppIconGenerator.net (recommended)
- MakeAppIcon.com
- AppIcon.co

### Design Tools
- Figma (free)
- Inkscape (free, open-source)
- Photopea.com (free, online Photoshop alternative)

### Icon Templates
- Search Figma Community: "iOS app icon template"
- Sketch App Resources
- Apple Design Resources

### Tutorials
- [Apple HIG - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [iOS Icon Design Best Practices](https://ivomynttinen.com/blog/ios-design-guidelines)

---

## Troubleshooting

**Issue**: Icon appears blurry on device
- **Solution**: Ensure you're using @2x and @3x sizes, not @1x scaled up

**Issue**: Icon has white border/background
- **Solution**: Ensure PNG has no transparency OR fill background with color

**Issue**: "Asset validation failed" in Xcode
- **Solution**: Ensure all required sizes are present
- **Solution**: Check files are PNG format
- **Solution**: Verify dimensions are exact

**Issue**: Icon doesn't match brand
- **Solution**: Use brand colors (#007AFF blue, #34C759 green)
- **Solution**: Simplify design - less is more

---

## Summary

**Fastest Method**:
1. Use SVG template → Export 1024×1024 PNG
2. Upload to AppIconGenerator.net
3. Download ZIP
4. Add to Xcode
5. ✅ Done in 10 minutes

**Best Quality Method**:
1. Design custom icon in Figma/Illustrator
2. Export 1024×1024 PNG
3. Use ImageMagick or generator for all sizes
4. Test on real device
5. ✅ Professional result in 1-2 hours

**Both methods work - choose based on time/quality needs!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Time**: 10 minutes (using template) to 2 hours (custom design)
