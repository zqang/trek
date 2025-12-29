//
//  FormattersTests.swift
//  TrekTests
//
//  Created on December 29, 2025.
//

import XCTest
@testable import Trek

final class FormattersTests: XCTestCase {

    // MARK: - Distance Tests

    func testFormatDistance_Metric_Kilometers() {
        let distance = 5432.0 // meters
        let formatted = Formatters.formatDistance(distance, unit: .metric)
        XCTAssertEqual(formatted, "5.43 km")
    }

    func testFormatDistance_Metric_Meters() {
        let distance = 543.0 // meters
        let formatted = Formatters.formatDistance(distance, unit: .metric)
        XCTAssertEqual(formatted, "543 m")
    }

    func testFormatDistance_Imperial_Miles() {
        let distance = 8047.0 // meters (~5 miles)
        let formatted = Formatters.formatDistance(distance, unit: .imperial)
        XCTAssertEqual(formatted, "5.00 mi")
    }

    func testFormatDistance_Imperial_Feet() {
        let distance = 152.0 // meters (~500 feet)
        let formatted = Formatters.formatDistance(distance, unit: .imperial)
        XCTAssertEqual(formatted, "499 ft")
    }

    func testFormatDistance_Zero() {
        let distance = 0.0
        let metricFormatted = Formatters.formatDistance(distance, unit: .metric)
        let imperialFormatted = Formatters.formatDistance(distance, unit: .imperial)

        XCTAssertEqual(metricFormatted, "0 m")
        XCTAssertEqual(imperialFormatted, "0 ft")
    }

    // MARK: - Pace Tests

    func testFormatPace_Metric() {
        let pace = 360.0 // seconds per km (6:00/km)
        let formatted = Formatters.formatPace(pace, unit: .metric)
        XCTAssertEqual(formatted, "6:00 /km")
    }

    func testFormatPace_Imperial() {
        let pace = 360.0 // seconds per km
        let formatted = Formatters.formatPace(pace, unit: .imperial)
        // 360 seconds/km * 1.60934 = ~579 seconds/mile (9:39/mi)
        XCTAssertTrue(formatted.hasPrefix("9:"))
    }

    func testFormatPace_FastPace() {
        let pace = 180.0 // 3:00/km (very fast)
        let formatted = Formatters.formatPace(pace, unit: .metric)
        XCTAssertEqual(formatted, "3:00 /km")
    }

    func testFormatPace_SlowPace() {
        let pace = 600.0 // 10:00/km
        let formatted = Formatters.formatPace(pace, unit: .metric)
        XCTAssertEqual(formatted, "10:00 /km")
    }

    func testFormatPace_Zero() {
        let pace = 0.0
        let formatted = Formatters.formatPace(pace, unit: .metric)
        XCTAssertEqual(formatted, "0:00 /km")
    }

    // MARK: - Speed Tests

    func testFormatSpeed_Metric() {
        let speed = 10.0 // m/s (36 km/h)
        let formatted = Formatters.formatSpeed(speed, unit: .metric)
        XCTAssertEqual(formatted, "36.0 km/h")
    }

    func testFormatSpeed_Imperial() {
        let speed = 10.0 // m/s (~22.4 mph)
        let formatted = Formatters.formatSpeed(speed, unit: .imperial)
        XCTAssertTrue(formatted.hasPrefix("22."))
    }

    func testFormatSpeed_Zero() {
        let speed = 0.0
        let formatted = Formatters.formatSpeed(speed, unit: .metric)
        XCTAssertEqual(formatted, "0.0 km/h")
    }

    // MARK: - Elevation Tests

    func testFormatElevation_Metric() {
        let elevation = 125.5
        let formatted = Formatters.formatElevation(elevation, unit: .metric)
        XCTAssertEqual(formatted, "126 m")
    }

    func testFormatElevation_Imperial() {
        let elevation = 100.0 // meters (~328 feet)
        let formatted = Formatters.formatElevation(elevation, unit: .imperial)
        XCTAssertTrue(formatted.hasSuffix(" ft"))
    }

    func testFormatElevation_Zero() {
        let elevation = 0.0
        let metricFormatted = Formatters.formatElevation(elevation, unit: .metric)
        let imperialFormatted = Formatters.formatElevation(elevation, unit: .imperial)

        XCTAssertEqual(metricFormatted, "0 m")
        XCTAssertEqual(imperialFormatted, "0 ft")
    }

    // MARK: - Duration Tests

    func testFormattedDuration_HoursMinutesSeconds() {
        let duration: TimeInterval = 3661 // 1:01:01
        let formatted = duration.formattedDuration
        XCTAssertEqual(formatted, "1:01:01")
    }

    func testFormattedDuration_MinutesSeconds() {
        let duration: TimeInterval = 125 // 2:05
        let formatted = duration.formattedDuration
        XCTAssertEqual(formatted, "2:05")
    }

    func testFormattedDuration_Seconds() {
        let duration: TimeInterval = 45
        let formatted = duration.formattedDuration
        XCTAssertEqual(formatted, "0:45")
    }

    func testFormattedDuration_Zero() {
        let duration: TimeInterval = 0
        let formatted = duration.formattedDuration
        XCTAssertEqual(formatted, "0:00")
    }

    func testFormattedDuration_LongDuration() {
        let duration: TimeInterval = 10800 // 3 hours
        let formatted = duration.formattedDuration
        XCTAssertEqual(formatted, "3:00:00")
    }
}
