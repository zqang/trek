# Trek Testing Guide

**Created**: December 29, 2025

## Overview

This document provides comprehensive guidance on testing the Trek fitness tracking app. It covers unit tests, integration tests, UI tests, and testing best practices.

## Test Structure

```
Trek/
├── TrekTests/                    # Unit & Integration Tests
│   ├── Utilities/
│   │   └── TestHelpers.swift    # Test utilities and assertions
│   ├── Mocks/
│   │   └── MockActivityService.swift
│   ├── Services/
│   │   ├── FormattersTests.swift
│   │   ├── KalmanFilterTests.swift
│   │   └── OfflineQueueTests.swift
│   └── ViewModels/
│       └── ActivitiesViewModelTests.swift
└── TrekUITests/                  # UI Tests
    └── (UI test files)
```

## Running Tests

### Via Xcode
1. Open `Trek.xcodeproj` in Xcode
2. Select a test file or test class
3. Click the diamond icon next to the test/class
4. Or press `Cmd + U` to run all tests

### Via Command Line
```bash
# Run all tests
xcodebuild test -scheme Trek -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Run specific test suite
xcodebuild test -scheme Trek -only-testing:TrekTests

# Run specific test class
xcodebuild test -scheme Trek -only-testing:TrekTests/FormattersTests

# Run specific test method
xcodebuild test -scheme Trek -only-testing:TrekTests/FormattersTests/testFormatDistance_Metric_Kilometers
```

## Test Coverage Goals

| Component Type | Target Coverage |
|----------------|-----------------|
| Services       | 80%+            |
| ViewModels     | 70%+            |
| Utilities      | 90%+            |
| Critical Paths | 100%            |

### Critical Paths
- Activity recording flow
- Activity saving (online & offline)
- GPS tracking and filtering
- Offline queue and sync
- User authentication

## Writing Tests

### Unit Test Template

```swift
import XCTest
@testable import Trek

final class YourServiceTests: XCTestCase {
    var service: YourService!

    override func setUp() {
        super.setUp()
        service = YourService()
    }

    override func tearDown() {
        service = nil
        super.tearDown()
    }

    // MARK: - Test Category

    func testMethod_Condition_ExpectedResult() {
        // Arrange
        let input = "test"

        // Act
        let result = service.method(input)

        // Assert
        XCTAssertEqual(result, expected)
    }
}
```

### Async Test Template

```swift
func testAsyncMethod() async {
    // Arrange
    let service = YourService()

    // Act & Assert
    await XCTAssertNoThrowAsync(
        try await service.asyncMethod()
    )
}
```

### ViewModel Test Template

```swift
@MainActor
final class YourViewModelTests: XCTestCase {
    var viewModel: YourViewModel!

    override func setUp() {
        super.setUp()
        viewModel = YourViewModel()
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testProperty_UpdatesCorrectly() {
        viewModel.property = "new value"
        XCTAssertEqual(viewModel.property, "new value")
    }
}
```

## Test Utilities

### MockData
Create mock objects for testing:

```swift
// Mock User
let user = MockData.createMockUser(
    id: "test_123",
    email: "test@example.com"
)

// Mock Activity
let activity = MockData.createMockActivity(
    distance: 5000,
    duration: 1800,
    type: .run
)

// Mock Route
let route = MockData.createMockRoute(count: 100)

// Mock Location
let location = MockData.createMockCLLocation(
    latitude: 37.33182,
    longitude: -122.03118
)
```

### Custom Assertions

```swift
// Approximate equality for doubles
XCTAssertApproximatelyEqual(value1, value2, accuracy: 0.01)

// Activity assertion
XCTAssertActivity(
    activity,
    hasDistance: 5000,
    duration: 1800,
    type: .run
)
```

### Async Helpers

```swift
// Wait for async operation
waitForAsync(timeout: 2.0) {
    try await service.asyncMethod()
}

// Assert no throw async
await XCTAssertNoThrowAsync(
    try await service.method()
)

// Assert throws async
await XCTAssertThrowsErrorAsync(
    try await service.methodThatThrows()
)
```

## Test Categories

### 1. Formatters Tests
**File**: `FormattersTests.swift`

Tests all formatting functions:
- Distance (metric/imperial, km/m, mi/ft)
- Pace (min/km, min/mi)
- Speed (km/h, mph)
- Elevation (m, ft)
- Duration (HH:MM:SS format)

**Example**:
```swift
func testFormatDistance_Metric_Kilometers() {
    let distance = 5432.0 // meters
    let formatted = Formatters.formatDistance(distance, unit: .metric)
    XCTAssertEqual(formatted, "5.43 km")
}
```

### 2. KalmanFilter Tests
**File**: `KalmanFilterTests.swift`

Tests GPS smoothing algorithm:
- First location handling
- Multi-location smoothing
- Noise reduction
- Accuracy weighting
- Large jump handling
- Reset functionality
- Performance

**Example**:
```swift
func testFilter_NoisyData_ReducesNoise() {
    // Add noisy GPS data
    // Verify filtered data has lower variance
}
```

### 3. OfflineQueue Tests
**File**: `OfflineQueueTests.swift`

Tests offline operation queueing:
- Enqueue/dequeue operations
- Retry count management
- Queue statistics
- Persistence
- Operation filtering

**Example**:
```swift
func testEnqueue_AddsOperation() {
    offlineQueue.queueActivity(activity, operation: .saveActivity)
    XCTAssertEqual(offlineQueue.queueCount, 1)
}
```

### 4. ViewModel Tests
**File**: `ActivitiesViewModelTests.swift`

Tests ViewModel logic:
- Initialization
- Filtering (by type, search)
- Sorting (6 sort orders)
- State management
- Data transformations

**Example**:
```swift
func testSetSortOrder_DistanceDescending_SortsCorrectly() {
    viewModel.activities = [shortRun, mediumRun, longRun]
    viewModel.setSortOrder(.distanceDescending)
    XCTAssertEqual(viewModel.activities[0].distance, 10000)
}
```

## Testing Best Practices

### 1. Test Naming
Use descriptive names following the pattern:
```
test[Method]_[Condition]_[ExpectedResult]
```

Examples:
- `testFormatDistance_Metric_Kilometers`
- `testFilter_NoisyData_ReducesNoise`
- `testEnqueue_MultipleOperations`

### 2. AAA Pattern
Structure tests with:
- **Arrange**: Set up test data
- **Act**: Execute the method
- **Assert**: Verify results

```swift
func testExample() {
    // Arrange
    let service = MyService()
    let input = "test"

    // Act
    let result = service.process(input)

    // Assert
    XCTAssertEqual(result, "expected")
}
```

### 3. Test Independence
- Each test should be independent
- Use `setUp()` and `tearDown()`
- Don't rely on test execution order
- Clean up after tests

### 4. Mock External Dependencies
- Use mock services for Firestore
- Use mock location data for GPS tests
- Don't make real network calls in unit tests

### 5. Test Edge Cases
Always test:
- Zero values
- Negative values
- Empty arrays/strings
- Nil values
- Boundary conditions
- Error conditions

## Common Test Patterns

### Testing Published Properties
```swift
func testPublishedProperty_UpdatesCorrectly() {
    let expectation = expectation(description: "Property updated")

    let cancellable = viewModel.$property
        .dropFirst()
        .sink { value in
            XCTAssertEqual(value, expectedValue)
            expectation.fulfill()
        }

    viewModel.updateProperty()

    waitForExpectations(timeout: 1.0)
    cancellable.cancel()
}
```

### Testing Async/Await
```swift
func testAsyncMethod() async throws {
    let result = try await service.asyncMethod()
    XCTAssertNotNil(result)
}
```

### Performance Testing
```swift
func testMethodPerformance() {
    measure {
        for _ in 0..<1000 {
            service.method()
        }
    }
}
```

### Testing Errors
```swift
func testMethod_InvalidInput_ThrowsError() async {
    await XCTAssertThrowsErrorAsync(
        try await service.methodThatThrows()
    ) { error in
        XCTAssertTrue(error is ServiceError)
    }
}
```

## Integration Tests

Integration tests verify components work together:

```swift
func testActivityRecordingFlow_EndToEnd() async {
    // 1. Start location service
    locationService.startTracking()

    // 2. Simulate GPS points
    for point in mockRoute {
        locationService.processLocation(point)
    }

    // 3. Stop tracking
    let stats = locationService.stopTracking()

    // 4. Save activity
    let activityId = try await activityService.saveActivity(activity)

    // 5. Verify
    XCTAssertNotNil(activityId)
    XCTAssertGreaterThan(stats.distance, 0)
}
```

## UI Tests

UI tests verify user interface interactions:

```swift
func testRecordActivity_FullFlow() {
    let app = XCUIApplication()
    app.launch()

    // Navigate to recording
    app.tabBars.buttons["Record"].tap()

    // Start recording
    app.buttons["Start"].tap()

    // Verify recording state
    XCTAssertTrue(app.staticTexts["Recording"].exists)

    // Stop recording
    app.buttons["Finish"].tap()

    // Verify summary appears
    XCTAssertTrue(app.staticTexts["Activity Summary"].exists)
}
```

## Test Data Management

### Using MockData
```swift
// Create consistent test data
let user = MockData.createMockUser()
let activity = MockData.createMockActivity()
let route = MockData.createMockRoute(count: 100)
```

### Custom Test Data
```swift
// Create specific test scenarios
let shortActivity = MockData.createMockActivity(distance: 1000, duration: 300)
let longActivity = MockData.createMockActivity(distance: 42195, duration: 10800)
```

## Continuous Integration

### Running Tests in CI
```yaml
# Example GitHub Actions workflow
- name: Run Tests
  run: |
    xcodebuild test \
      -scheme Trek \
      -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
      -enableCodeCoverage YES
```

### Code Coverage
- Enable code coverage in scheme settings
- Aim for 70%+ overall coverage
- Review coverage reports regularly

## Debugging Tests

### Print Debugging
```swift
func testMethod() {
    let result = service.method()
    print("Result: \(result)")
    XCTAssertEqual(result, expected)
}
```

### Breakpoint Debugging
- Set breakpoints in test methods
- Step through test execution
- Inspect variables

### Test Failure Messages
```swift
XCTAssertEqual(
    result,
    expected,
    "Expected \(expected) but got \(result)"
)
```

## Test Maintenance

### Regular Reviews
- Review tests monthly
- Remove obsolete tests
- Update tests for new features
- Refactor duplicate code

### Documentation
- Document complex test scenarios
- Explain non-obvious assertions
- Add comments for edge cases

## Resources

- [XCTest Documentation](https://developer.apple.com/documentation/xctest)
- [Testing in Xcode](https://developer.apple.com/documentation/xcode/testing-your-apps-in-xcode)
- [Async Testing](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations)

## Next Steps

After Phase 9:
1. Achieve 70%+ test coverage
2. Set up CI/CD pipeline
3. Add performance benchmarks
4. Implement crash reporting tests
5. Add accessibility tests

---

**Last Updated**: December 29, 2025
**Test Framework**: XCTest
**Current Coverage**: TBD (run tests to calculate)
