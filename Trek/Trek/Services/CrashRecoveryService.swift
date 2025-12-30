//
//  CrashRecoveryService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import os.log

private let logger = Logger(subsystem: "com.trek", category: "CrashRecoveryService")

class CrashRecoveryService {
    private let userDefaults = UserDefaults.standard
    private let recordingStateKey = "pendingRecording"

    // MARK: - Save Recording State
    func saveRecordingState(_ state: RecordingState) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(state)
            userDefaults.set(data, forKey: recordingStateKey)
            userDefaults.synchronize()
        } catch {
            logger.error("Failed to save recording state: \(error.localizedDescription)")
        }
    }

    // MARK: - Load Recording State
    func loadRecordingState() -> RecordingState? {
        guard let data = userDefaults.data(forKey: recordingStateKey) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let state = try decoder.decode(RecordingState.self, from: data)
            return state
        } catch {
            logger.error("Failed to load recording state: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Clear Recording State
    func clearRecordingState() {
        userDefaults.removeObject(forKey: recordingStateKey)
        userDefaults.synchronize()
    }

    // MARK: - Check for Pending Recording
    func hasPendingRecording() -> Bool {
        return userDefaults.data(forKey: recordingStateKey) != nil
    }
}

// MARK: - Recording State
struct RecordingState: Codable {
    let activityType: ActivityType
    let startTime: Date
    let route: [LocationPoint]
    let distance: Double
    let duration: TimeInterval
    let elevationGain: Double
    let splits: [Split]
    let isPaused: Bool
    let pausedDuration: TimeInterval
    let lastSaved: Date

    init(
        activityType: ActivityType,
        startTime: Date,
        route: [LocationPoint],
        distance: Double,
        duration: TimeInterval,
        elevationGain: Double,
        splits: [Split],
        isPaused: Bool,
        pausedDuration: TimeInterval
    ) {
        self.activityType = activityType
        self.startTime = startTime
        self.route = route
        self.distance = distance
        self.duration = duration
        self.elevationGain = elevationGain
        self.splits = splits
        self.isPaused = isPaused
        self.pausedDuration = pausedDuration
        self.lastSaved = Date()
    }

    // Create Activity from recording state
    func toActivity(userId: String, endTime: Date, name: String? = nil) -> Activity {
        Activity(
            id: nil,
            userId: userId,
            name: name ?? "\(startTime.timeOfDay) \(activityType.displayName)",
            type: activityType,
            startTime: startTime,
            endTime: endTime,
            distance: distance,
            duration: duration,
            elevationGain: elevationGain,
            route: route,
            splits: splits,
            isPrivate: true,  // Default to private
            createdAt: Date()
        )
    }
}
