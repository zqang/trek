//
//  Formatters.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation

struct Formatters {

    // MARK: - Distance Formatting
    static func formatDistance(_ meters: Double, unit: UnitSystem) -> String {
        switch unit {
        case .metric:
            if meters < 1000 {
                return String(format: "%.0f m", meters)
            } else {
                return String(format: "%.2f km", meters / 1000)
            }
        case .imperial:
            let miles = meters / 1609.34
            if miles < 0.1 {
                let feet = meters * 3.28084
                return String(format: "%.0f ft", feet)
            } else {
                return String(format: "%.2f mi", miles)
            }
        }
    }

    // MARK: - Pace Formatting
    static func formatPace(_ secondsPerKm: Double, unit: UnitSystem) -> String {
        let paceValue = unit == .imperial ? secondsPerKm * 1.60934 : secondsPerKm
        let minutes = Int(paceValue / 60)
        let seconds = Int(paceValue.truncatingRemainder(dividingBy: 60))
        return String(format: "%d:%02d", minutes, seconds)
    }

    // MARK: - Speed Formatting
    static func formatSpeed(_ metersPerSecond: Double, unit: UnitSystem) -> String {
        switch unit {
        case .metric:
            let kmh = metersPerSecond * 3.6
            return String(format: "%.1f km/h", kmh)
        case .imperial:
            let mph = metersPerSecond * 2.23694
            return String(format: "%.1f mph", mph)
        }
    }

    // MARK: - Duration Formatting
    static func formatDuration(_ seconds: TimeInterval) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        let secs = Int(seconds) % 60

        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        } else {
            return String(format: "%d:%02d", minutes, secs)
        }
    }

    // MARK: - Elevation Formatting
    static func formatElevation(_ meters: Double, unit: UnitSystem) -> String {
        switch unit {
        case .metric:
            return String(format: "%.0f m", meters)
        case .imperial:
            let feet = meters * 3.28084
            return String(format: "%.0f ft", feet)
        }
    }

    // MARK: - Date Formatting
    static func formatDate(_ date: Date, style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    static func formatDateRelative(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
