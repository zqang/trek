//
//  HapticManager.swift
//  Trek
//
//  Created on December 29, 2025.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()

    private init() {}

    // MARK: - Notification Feedback

    func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }

    func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    // MARK: - Impact Feedback

    func light() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func medium() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func heavy() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }

    func soft() {
        if #available(iOS 17.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        } else {
            light()
        }
    }

    func rigid() {
        if #available(iOS 17.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        } else {
            heavy()
        }
    }

    // MARK: - Selection Feedback

    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }

    // MARK: - Contextual Haptics

    func startRecording() {
        heavy()
    }

    func stopRecording() {
        success()
    }

    func pauseRecording() {
        medium()
    }

    func resumeRecording() {
        medium()
    }

    func saveActivity() {
        success()
    }

    func deleteActivity() {
        warning()
    }

    func buttonTap() {
        light()
    }

    func toggleSwitch() {
        selection()
    }

    func pullToRefresh() {
        soft()
    }

    func navigationPush() {
        soft()
    }

    func errorOccurred() {
        error()
    }
}
