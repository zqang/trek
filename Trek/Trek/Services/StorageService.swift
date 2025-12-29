//
//  StorageService.swift
//  Trek
//
//  Created on December 29, 2025.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    private let storage = Storage.storage()

    // MARK: - Upload Profile Photo
    func uploadProfilePhoto(userId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw StorageError.invalidImage
        }

        let fileName = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference()
            .child("profile_photos")
            .child(userId)
            .child(fileName)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Upload the file
        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)

        // Get the download URL
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
    }

    // MARK: - Delete Profile Photo
    func deleteProfilePhoto(url: String) async throws {
        let storageRef = storage.reference(forURL: url)
        try await storageRef.delete()
    }

    // MARK: - Upload Activity Photo
    func uploadActivityPhoto(userId: String, activityId: String, image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw StorageError.invalidImage
        }

        let fileName = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference()
            .child("activity_photos")
            .child(userId)
            .child(activityId)
            .child(fileName)

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL.absoluteString
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
            return "Failed to upload the image"
        case .deleteFailed:
            return "Failed to delete the image"
        }
    }
}
