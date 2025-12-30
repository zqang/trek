//
//  StorageService.swift
//  Trek
//
//  Local file storage service.
//

import Foundation
import UIKit

class StorageService {
    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var profilePhotosDirectory: URL {
        documentsDirectory.appendingPathComponent("profile_photos")
    }

    private var activityPhotosDirectory: URL {
        documentsDirectory.appendingPathComponent("activity_photos")
    }

    init() {
        createDirectoriesIfNeeded()
    }

    private func createDirectoriesIfNeeded() {
        try? fileManager.createDirectory(at: profilePhotosDirectory, withIntermediateDirectories: true)
        try? fileManager.createDirectory(at: activityPhotosDirectory, withIntermediateDirectories: true)
    }

    // MARK: - Upload Profile Photo
    func uploadProfilePhoto(userId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw StorageError.invalidImage
        }

        let userDirectory = profilePhotosDirectory.appendingPathComponent(userId)
        try? fileManager.createDirectory(at: userDirectory, withIntermediateDirectories: true)

        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = userDirectory.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            throw StorageError.uploadFailed
        }
    }

    // MARK: - Delete Profile Photo
    func deleteProfilePhoto(path: String) async throws {
        let fileURL = URL(fileURLWithPath: path)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw StorageError.deleteFailed
        }
    }

    // MARK: - Upload Activity Photo
    func uploadActivityPhoto(userId: String, activityId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.invalidImage
        }

        let activityDirectory = activityPhotosDirectory
            .appendingPathComponent(userId)
            .appendingPathComponent(activityId)
        try? fileManager.createDirectory(at: activityDirectory, withIntermediateDirectories: true)

        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = activityDirectory.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            throw StorageError.uploadFailed
        }
    }

    // MARK: - Load Image
    func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }

    // MARK: - Delete All User Data
    func deleteAllUserData(userId: String) async throws {
        let profileDir = profilePhotosDirectory.appendingPathComponent(userId)
        let activityDir = activityPhotosDirectory.appendingPathComponent(userId)

        try? fileManager.removeItem(at: profileDir)
        try? fileManager.removeItem(at: activityDir)
    }
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case invalidImage
    case uploadFailed
    case deleteFailed

    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Unable to process the image"
        case .uploadFailed:
            return "Failed to save the image"
        case .deleteFailed:
            return "Failed to delete the image"
        }
    }
}
