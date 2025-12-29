# GPS Testing Guide for Trek

This guide provides comprehensive instructions for testing GPS functionality in the Trek app.

---

## Table of Contents
1. [Simulator Testing](#simulator-testing)
2. [Real Device Testing](#real-device-testing)
3. [Testing Scenarios](#testing-scenarios)
4. [GPS Debug View](#gps-debug-view)
5. [Accuracy Validation](#accuracy-validation)
6. [Troubleshooting](#troubleshooting)

---

## Simulator Testing

### Setting Up Simulator Location

**Method 1: Xcode Location Simulation**
1. Run the app in simulator
2. In Xcode: Debug → Simulate Location
3. Choose from presets:
   - Apple (Cupertino)
   - City Bicycle Ride
   - City Run
   - Freeway Drive
   - Custom GPX file

**Method 2: Custom GPX File**
Create a GPX file for realistic route testing:

```xml
<?xml version="1.0"?>
<gpx version="1.1" creator="Trek Test">
  <trk>
    <name>Test Route</name>
    <trkseg>
      <trkpt lat="37.33182" lon="-122.03118">
        <ele>20</ele>
        <time>2025-01-01T00:00:00Z</time>
      </trkpt>
      <trkpt lat="37.33192" lon="-122.03128">
        <ele>21</ele>
        <time>2025-01-01T00:00:10Z</time>
      </trkpt>
      <!-- Add more points -->
    </trkseg>
  </trk>
</gpx>
```

**Using Custom GPX:**
1. Add GPX file to Xcode project
2. Run app in simulator
3. Debug → Simulate Location → [Your GPX filename]

### Simulator Limitations
- ❌ No realistic GPS accuracy simulation
- ❌ No signal loss simulation
- ❌ No battery drain measurement
- ✅ Good for UI testing
- ✅ Good for route visualization
- ✅ Good for basic functionality testing

---

## Real Device Testing

### Prerequisites
1. Physical iPhone with GPS capability
2. iOS 16.0 or later
3. Xcode with provisioning profile
4. Outdoor location for accurate GPS signal

### Initial Setup
1. Build and install app on device
2. Go to Settings → Privacy & Security → Location Services
3. Ensure Location Services is ON
4. Find Trek app and set to "While Using the App"

### Testing Environment
**Best Conditions:**
- Clear sky visibility
- Open outdoor area (parks, fields)
- Away from tall buildings
- Good weather (no heavy clouds)

**Challenging Conditions (for testing):**
- Urban canyons (tall buildings)
- Forests with tree cover
- Tunnels and underpasses
- Indoor/covered areas

---

## Testing Scenarios

### Scenario 1: Basic GPS Tracking
**Objective**: Verify GPS tracking works correctly

**Steps:**
1. Open Trek app
2. Go to Record tab
3. Grant location permission when prompted
4. Wait for GPS signal (check indicator)
5. Select activity type (Run/Ride/Walk)
6. Tap Start
7. Walk/run for 5-10 minutes
8. Observe live stats updating
9. Tap Finish

**Expected Results:**
- ✅ GPS signal indicator shows green (excellent/good)
- ✅ Distance increases accurately
- ✅ Duration timer runs continuously
- ✅ Pace/speed updates in real-time
- ✅ Route displays on map

**Success Criteria:**
- Distance accuracy within ±2% of known distance
- No dropped GPS points (gaps in route)
- Smooth route without zigzags

### Scenario 2: Permission Flow
**Objective**: Test location permission handling

**Steps:**
1. Fresh install (or reset permissions)
2. Open app, go to Record tab
3. Observe permission request screen
4. Tap "Allow Location Access"
5. Grant "While Using the App" in system dialog
6. Verify permission granted

**Test Denial:**
1. Deny permission in system dialog
2. Observe error state
3. Tap "Open Settings" button
4. Enable permission in Settings
5. Return to app
6. Verify permission now granted

### Scenario 3: GPS Signal Quality
**Objective**: Test GPS in various signal conditions

**Locations to Test:**
1. **Open Field** (Best signal)
   - Expected: Excellent (≤10m accuracy)
   - Green indicator

2. **Near Buildings** (Good signal)
   - Expected: Good (10-20m accuracy)
   - Green indicator

3. **Under Trees** (Fair signal)
   - Expected: Fair (20-50m accuracy)
   - Orange indicator

4. **Urban Canyon** (Poor signal)
   - Expected: Poor (>50m accuracy)
   - Red indicator

5. **Indoors** (No signal)
   - Expected: No location data
   - Gray indicator

### Scenario 4: Pause and Resume
**Objective**: Verify pause/resume works correctly

**Steps:**
1. Start tracking an activity
2. Walk for 2 minutes
3. Tap Pause
4. Wait 1 minute (stationary)
5. Tap Resume
6. Walk for 2 more minutes
7. Finish activity

**Expected Results:**
- ✅ Timer stops during pause
- ✅ Distance doesn't increase during pause
- ✅ GPS updates stop during pause
- ✅ Timer resumes correctly
- ✅ Total duration excludes paused time

### Scenario 5: Signal Loss and Recovery
**Objective**: Test GPS signal loss handling

**Steps:**
1. Start tracking outdoors
2. Walk into a tunnel or parking garage
3. Wait for signal loss
4. Return to open area
5. Wait for signal recovery
6. Finish activity

**Expected Results:**
- ⚠️ Signal indicator shows red/gray in tunnel
- ⚠️ Location error message displayed
- ✅ Timer continues running
- ✅ GPS resumes when signal returns
- ✅ Route may have interpolated section

### Scenario 6: Battery Consumption
**Objective**: Measure battery drain during tracking

**Steps:**
1. Fully charge device
2. Note starting battery percentage
3. Start tracking activity
4. Record for 60 minutes
5. Note ending battery percentage
6. Calculate drain

**Target Battery Drain:**
- ≤10% per hour of active tracking
- Compare with baseline (screen on, no tracking)

**To Measure:**
- Settings → Battery → Battery Usage by App
- Look for Trek app usage

### Scenario 7: Long-Distance Tracking
**Objective**: Test extended tracking session

**Steps:**
1. Start tracking
2. Walk/run for 10+ km or 60+ minutes
3. Monitor memory usage
4. Verify no crashes or slowdowns
5. Finish and review data

**Expected Results:**
- ✅ No memory leaks
- ✅ App remains responsive
- ✅ All GPS points captured
- ✅ Stats remain accurate
- ✅ Route renders smoothly

### Scenario 8: Kalman Filter Effectiveness
**Objective**: Verify GPS smoothing works

**Steps:**
1. Record activity while stationary for 5 minutes
2. Record activity with slow walking
3. Review GPS points in debug view

**Expected Results:**
- ✅ Stationary drift <5m over 5 minutes
- ✅ No random jumps in location
- ✅ Smooth route without zigzags
- ✅ Speed readings are realistic

---

## GPS Debug View

### Accessing Debug View
1. Run app in DEBUG mode
2. Go to Record tab
3. Tap menu (⋯) in top right
4. Select "GPS Debug"

### Debug View Information
The debug view shows:
- **Permission Status**: Current authorization state
- **GPS Signal**: Accuracy, lat/lon, altitude, speed
- **Tracking Status**: Is tracking, is paused, distance, duration
- **Route Information**: GPS points collected, splits
- **Controls**: Start/pause/resume/stop buttons

### Using Debug View for Testing
1. **Monitor GPS Accuracy**: Watch accuracy value in real-time
2. **Check Signal Quality**: Verify signal strength in different locations
3. **Test Controls**: Use debug controls to test state transitions
4. **Verify Data Collection**: Ensure GPS points are being captured

---

## Accuracy Validation

### Method 1: Known Distance Route
1. Find a measured track (e.g., 400m track)
2. Record one lap
3. Compare Trek distance to actual distance
4. Calculate error percentage:
   ```
   Error = |Trek Distance - Actual Distance| / Actual Distance × 100%
   ```
5. **Target**: ≤2% error

### Method 2: Compare with Another GPS App
1. Start Trek tracking
2. Simultaneously start Strava/Nike Run Club
3. Record same activity
4. Compare final distances
5. **Target**: Within 1-2% of other app

### Method 3: Google Maps Measurement
1. Record an activity
2. Export route as GPX
3. Import to Google Maps "Measure Distance" tool
4. Compare measured distance
5. **Target**: Within 2% of measured distance

### Distance Accuracy Benchmarks
| Scenario | Expected Accuracy |
|----------|-------------------|
| Open field, clear sky | ±1% |
| Suburban area | ±2% |
| Light tree cover | ±3% |
| Urban area | ±5% |
| Heavy tree cover | ±8% |

---

## Common Issues and Solutions

### Issue 1: "Location Services Disabled"
**Symptoms**: App shows permission error
**Solution:**
1. Settings → Privacy & Security → Location Services
2. Turn ON Location Services
3. Find Trek → Set to "While Using the App"

### Issue 2: Poor GPS Accuracy
**Symptoms**: Distance way off, erratic route
**Possible Causes:**
- Poor GPS signal (check surroundings)
- Assisted GPS not working (check cellular/WiFi)
- Device GPS hardware issue

**Solutions:**
1. Move to open area
2. Enable WiFi (helps with assisted GPS)
3. Restart device
4. Check other GPS apps for comparison

### Issue 3: GPS Not Updating
**Symptoms**: Location frozen, distance not increasing
**Solutions:**
1. Check permission is still granted
2. Force quit and restart app
3. Toggle Location Services off/on
4. Restart device

### Issue 4: High Battery Drain
**Symptoms**: Battery drains >15% per hour
**Solutions:**
1. Reduce screen brightness
2. Close other apps
3. Disable unnecessary location services
4. Check for iOS updates

### Issue 5: App Crashes During Tracking
**Symptoms**: App terminates unexpectedly
**Actions:**
1. Check crash logs in Xcode
2. Review memory usage
3. Test on different devices
4. Check for iOS compatibility issues

---

## Performance Metrics

### GPS Tracking Performance Targets

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| GPS Accuracy | ±2% | Known distance comparison |
| Update Frequency | 1Hz (every second) | Debug view monitoring |
| Battery Drain | <10% per hour | iOS Battery settings |
| Memory Usage | <50MB during tracking | Xcode Instruments |
| Stationary Drift | <5m over 5 minutes | Stationary test |
| Signal Acquisition | <30 seconds | Time to first fix |

### Kalman Filter Performance
- **Smoothing**: Reduce GPS noise by 30-50%
- **Accuracy**: Maintain ±5m horizontal accuracy
- **No lag**: Real-time updates without delay

---

## Testing Checklist

### Pre-Release Testing
- [ ] Test all permission scenarios
- [ ] Verify GPS accuracy on 10+ known routes
- [ ] Test in urban, suburban, and rural areas
- [ ] Test with poor signal conditions
- [ ] Verify pause/resume functionality
- [ ] Test signal loss and recovery
- [ ] Measure battery consumption
- [ ] Test long-duration tracking (60+ min)
- [ ] Verify Kalman filter effectiveness
- [ ] Test on multiple device models
- [ ] Test on different iOS versions

### Device Matrix
Recommended test devices:
- iPhone SE (small screen, older hardware)
- iPhone 13/14 (mid-range)
- iPhone 15 Pro (latest hardware)
- iOS 16.0 (minimum version)
- iOS 17.x (current version)
- iOS 18.x beta (upcoming version)

---

## Reporting Issues

### Information to Include
When reporting GPS issues:
1. Device model and iOS version
2. Location type (urban, rural, indoor, etc.)
3. GPS accuracy reading
4. Expected vs. actual distance
5. Screenshots of debug view
6. GPX export of route (if possible)
7. Steps to reproduce
8. Battery level during test

### Sample Bug Report
```
Title: GPS distance 15% higher than actual

Device: iPhone 14, iOS 17.2
Location: Urban area (downtown)
GPS Accuracy: 35-50m (Fair)
Expected: 5.0 km
Actual: 5.75 km (+15%)
Conditions: Partly cloudy, 3 PM
Battery: Started 85%, ended 78%

Steps to Reproduce:
1. Started tracking in urban area
2. Ran along measured 5km route
3. GPS signal was fair (orange) most of time
4. Finished with 5.75km recorded

Screenshots: [attached]
GPX File: [attached]
```

---

## Advanced Testing

### GPX File Analysis
Tools for analyzing recorded routes:
- **GPX Editor**: View and edit GPX files
- **GPXSee**: Visualize routes and elevation
- **Python gpxpy**: Programmatic analysis

### Automated Testing
Consider creating automated tests for:
- Permission state changes
- Location manager delegate callbacks
- Distance calculation algorithms
- Kalman filter effectiveness

### Stress Testing
1. Leave app tracking for 4+ hours
2. Record in airplane mode (offline)
3. Rapid pause/resume cycles
4. Location permission revocation during tracking
5. Memory pressure scenarios

---

## Resources

### Useful Tools
- **GPX Studio**: Create custom GPX files online
- **Xcode Instruments**: Profile performance and battery
- **GPSVisualizer**: Analyze and visualize GPX data
- **iOS Battery Usage**: Monitor app battery consumption

### Reference Apps
Compare with these apps for GPS accuracy:
- Strava
- Nike Run Club
- Runkeeper
- MapMyRun

### Documentation
- [Apple Core Location Documentation](https://developer.apple.com/documentation/corelocation)
- [GPS Accuracy Best Practices](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/LocationAwarenessPG/CoreLocation/CoreLocation.html)

---

**Last Updated**: December 29, 2025
**Trek Version**: 1.0.0 (MVP)
**Status**: Phase 3 Testing Guidelines
