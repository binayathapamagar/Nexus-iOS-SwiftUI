//
//  ImageUploader.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-09.
//

import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    
    private init() {}
    
    static func uploadUserProfileImage(for type: ImageUploader.type, _ image: UIImage, userId: String, uid: String? = nil) async throws -> String? {
        //For profile Pics, we can compress the image quality down to 0.25, in case the user uploads a huge image.
        //NOTE: For a thread image, limit the compression to maintain the quality.
        //NOTE: 0.0 represents the maximum compression (or lowest quality) while 1.0 represents the least compression (or best quality).
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let fileName = type == .Profile ? userId : userId + (uid ?? "")
        let imageFullPath = type.imagePath + fileName
        let storageRef = Storage.storage().reference(withPath: imageFullPath)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            let imageURL = try await storageRef.downloadURL()
            return imageURL.absoluteString
        } catch {
            print(#function, "DEBUG: Failed to upload the user's profile image to Firebase. \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension ImageUploader {
    enum type {
        case Profile,
             Thread
        
        var imagePath: String {
            switch self {
            case .Profile: return "/profile_images/"
            case .Thread: return "/thread_images/"
            }
        }
    }
}
