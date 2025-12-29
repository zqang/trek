# Trek Performance Testing Guide

**Created**: December 29, 2025

## Overview

Quick guide to test Trek's performance before App Store submission using Xcode Instruments.

## Prerequisites

- Xcode installed
- Trek built and running
- Real iPhone device (recommended) or Simulator

## Quick Performance Check (15 minutes)

### Test 1: App Launch Time

**Target**: < 2 seconds cold launch

```bash
# In Xcode
1. Product → Clean Build Folder (Cmd + Shift + K)
2. Quit Trek on device/simulator
3. Product → Run (Cmd + R)
4. Watch simulator/device

stopwatch from tap icon → first screen appears
```

**Result**:
- < 1s: Excellent ✅
- 1-2s: Good ✅
- 2-3s: Acceptable ⚠️
- > 3s: Needs optimization ❌

### Test 2: Memory Usage

**Target**: < 150 MB typical, < 300 MB during recording

```bash
# In Xcode
1. Run Trek on device
2. Debug Navigator (Cmd + 7)
3. Look at Memory gauge

Normal usage (browsing activities): ___ MB
During recording: ___ MB
After 30 min recording: ___ MB
```

**Result**:
- < 150 MB idle: Excellent ✅
- < 300 MB recording: Good ✅
- > 400 MB: Check for leaks ⚠️

### Test 3: GPS Recording (30-60 min)

**Critical Test** - Do this on real device!

1. Start new activity recording
2. Walk/run for 30-60 minutes
3. Monitor:
   - App doesn't crash ✅
   - GPS updates smoothly ✅
   - Stats calculate correctly ✅
   - Battery drain acceptable ✅

**Battery Drain**:
- < 20% for 60 min: Excellent ✅
- 20-30% for 60 min: Good ✅
- > 40% for 60 min: Too high ⚠️

---

## Instruments Profiling (30 minutes)

### Setup

```bash
# In Xcode
1. Product → Profile (Cmd + I)
2. Choose profiling template (see below)
3. Click Record (red button)
4. Use Trek normally
5. Stop recording
6. Analyze results
```

### Profile 1: Time Profiler

**Purpose**: Find CPU-intensive code

**Steps**:
1. Product → Profile → Time Profiler
2. Record
3. Use Trek:
   - Launch app
   - Navigate between tabs
   - Scroll activities list
   - View activity details
4. Stop after 2-3 minutes
5. Analyze Call Tree

**Look For**:
- Any single function using > 5% CPU
- Repeated calls to same function
- Unexpected heavy operations

**Common Issues**:
- Map rendering taking too long
- JSON parsing bottlenecks
- Image processing

### Profile 2: Allocations

**Purpose**: Track memory allocations

**Steps**:
1. Product → Profile → Allocations
2. Record
3. Use Trek:
   - Record activity
   - View activities
   - Navigate around
4. Stop
5. Look at "All Heap & Anonymous VM"

**Look For**:
- Memory growing continuously (leak!)
- Large allocations (> 10 MB single object)
- Unexpected memory spikes

**Check**:
- ViewModels released when views disappear?
- Images released from memory?
- Firebase listeners cleaned up?

### Profile 3: Leaks

**Purpose**: Find memory leaks

**Steps**:
1. Product → Profile → Leaks
2. Record
3. Use all Trek features:
   - Sign in/out
   - Record activity
   - View activities
   - Edit profile
   - Delete activity
4. Stop after 5 minutes
5. Check "Leaks" instrument

**Result**:
- **0 leaks**: Perfect! ✅
- **1-2 small leaks**: Investigate but acceptable
- **Multiple leaks**: Must fix ❌

**Common Leak Sources**:
- Closures capturing `self` strongly
- Firebase listeners not removed
- Timers not invalidated
- Notification observers not removed

### Profile 4: Energy Log

**Purpose**: Measure battery impact

**Steps**:
1. Product → Profile → Energy Log
2. Record
3. Record a 15-30 minute activity
4. Stop
5. Check "Energy Usage" graph

**Look For**:
- GPS: Should be highest (expected)
- CPU: Should be moderate
- Networking: Should be low/sporadic
- Display: Depends on screen time

**Energy Level**:
- Low-Medium: Great ✅
- High: Acceptable (GPS is intensive) ✅
- Very High: Investigate ⚠️

---

## Manual Testing Checklist

### Core Functionality

**Test on Real Device** (iPhone with iOS 16+):

- [ ] App launches without crash
- [ ] Sign up creates account
- [ ] Login works
- [ ] Location permission prompt appears
- [ ] Record activity (5+ minutes)
  - [ ] GPS updates smooth
  - [ ] Stats calculate correctly
  - [ ] Distance seems accurate
  - [ ] Map shows route
- [ ] Pause/resume works
- [ ] Finish and save activity
- [ ] Activity appears in list
- [ ] View activity details
- [ ] Edit activity name
- [ ] Delete activity
- [ ] Profile stats update
- [ ] Settings save correctly
- [ ] Export GPX works
- [ ] Sign out works

### Edge Cases

- [ ] No internet at launch (offline mode)
- [ ] Record activity offline
- [ ] Go online, activity syncs
- [ ] GPS permission denied → shows message
- [ ] Very long activity (2+ hours)
- [ ] Activity with 1000+ GPS points
- [ ] Rapid start/stop recording
- [ ] Low battery during recording
- [ ] App backgrounded during recording
- [ ] Device locked during recording

### Performance Tests

- [ ] Scroll 50+ activities smoothly
- [ ] Load activity with long route quickly
- [ ] Search responds immediately
- [ ] Filters apply without lag
- [ ] Maps render without delay
- [ ] Dark mode toggle is instant
- [ ] No janky animations
- [ ] No dropped frames during scroll

---

## Automated Testing

### Run Unit Tests

```bash
# Command line
xcodebuild test \
  -scheme Trek \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  -enableCodeCoverage YES

# Or in Xcode
Product → Test (Cmd + U)
```

**Expected**:
- All 60+ tests pass ✅
- No failures ❌
- Test coverage report generated

### Performance Tests

Already included in `KalmanFilterTests.swift`:

```swift
func testFilter_Performance() {
    measure {
        for _ in 0..<1000 {
            _ = kalmanFilter.filter(location)
        }
    }
}
```

**Baseline**: Establish on first run, should be consistent on subsequent runs.

---

## Network Conditions Testing

### Test with Network Link Conditioner

**Setup** (macOS):
1. Settings → Developer
2. Enable Developer Mode
3. Install "Additional Tools for Xcode"
4. Open "Network Link Conditioner"

**Test Scenarios**:

**1. 3G Network** (slow):
- Enable 3G profile
- Record activity
- Save activity
- Verify works (may be slower)

**2. 100% Loss** (offline):
- Enable 100% Loss profile
- Record activity
- Save activity
- Go online
- Verify sync works

**3. Lossy WiFi**:
- Enable "Very Bad Network"
- Test all features
- Should handle gracefully

---

## Device Testing Matrix

**Minimum**:
- [ ] iPhone SE (older/slower device)
- [ ] iPhone 14/15 (current gen)
- [ ] iOS 16.0 (minimum version)
- [ ] Latest iOS (17.x or 18.x)

**Recommended**:
- [ ] iPhone SE 2020 (iOS 16)
- [ ] iPhone 13 (iOS 17)
- [ ] iPhone 15 Pro (iOS 18 beta if available)
- [ ] iPad (if supporting)

---

## Performance Benchmarks

Record your results:

| Test | Device | Result | Target | Status |
|------|--------|--------|--------|--------|
| Cold Launch | iPhone 15 | ___ s | < 2s | |
| Warm Launch | iPhone 15 | ___ s | < 1s | |
| Memory (Idle) | iPhone 15 | ___ MB | < 150MB | |
| Memory (Recording) | iPhone 15 | ___ MB | < 300MB | |
| Battery (60 min) | iPhone 15 | ___% | < 30% | |
| Scroll FPS | iPhone 15 | ___ | 60 | |
| Save Activity | iPhone 15 | ___ s | < 1s | |

---

## Common Performance Issues & Fixes

### Issue: Slow Launch

**Causes**:
- Heavy initialization in `TrekApp.init()`
- Loading large data at startup
- Synchronous Firebase calls

**Fixes**:
- Defer non-critical init
- Load data asynchronously
- Use lazy loading

### Issue: High Memory

**Causes**:
- Images not released
- Activities kept in memory
- Large route data

**Fixes**:
- Release images when off-screen
- Implement pagination
- Simplify large routes

### Issue: Battery Drain

**Causes**:
- GPS update frequency too high
- Background tasks running
- Unnecessary network calls

**Fixes**:
- Reduce GPS frequency when stationary
- Stop GPS when paused
- Batch network requests

### Issue: Laggy Scrolling

**Causes**:
- Heavy views in list
- Map rendering in each cell
- Synchronous operations on main thread

**Fixes**:
- Use LazyVStack (already done ✅)
- Lazy load maps
- Move heavy work to background

---

## Pre-Submission Checklist

**Critical Performance Tests**:
- [ ] No crashes in normal usage (1 hour testing)
- [ ] App launch < 3 seconds
- [ ] No memory leaks (Instruments check)
- [ ] GPS recording works for 60+ minutes
- [ ] Battery drain acceptable (< 30% per hour)
- [ ] Scrolling smooth (60 FPS)
- [ ] All unit tests pass
- [ ] Works offline
- [ ] Works on iOS 16.0 minimum

**If all checked ✅, ready for submission!**

---

## Resources

- [Xcode Instruments Guide](https://developer.apple.com/documentation/instruments)
- [iOS Performance Tips](https://developer.apple.com/videos/performance)
- [Energy Efficiency Guide](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/)

---

## Quick Start

**Minimum Testing (30 min)**:
1. Run Time Profiler → check for hot spots
2. Run Leaks → verify 0 leaks
3. Test 30 min GPS recording on device
4. Run all unit tests
5. ✅ Ready!

**Thorough Testing (2 hours)**:
1. All Instruments profiles
2. 60 min GPS recording + battery check
3. Test on 3 devices
4. Test all edge cases
5. Network condition testing
6. ✅ Confident for launch!

---

**Performance testing ensures a great user experience!**

---

**Document Version**: 1.0
**Last Updated**: December 29, 2025
**Estimated Time**: 30 min (quick) to 2 hours (thorough)
