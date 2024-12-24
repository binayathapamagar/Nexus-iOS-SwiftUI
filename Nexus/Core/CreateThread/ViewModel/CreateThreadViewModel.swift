//
//  CreateThreadViewModel.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-10.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

class CreateThreadViewModel: ObservableObject {
    @Published var newThread: Thread? // Optional to notify when a new thread is added
    @Published var showLoadingSpinner = false
    
    @MainActor
    func uploadThread(with content: String, image: UIImage?) async throws {
        showLoadingSpinner = true
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        defer {
            showLoadingSpinner = false
        }
        
        var imageUrl: String?
        
        if let image = image {
            guard let uploadedImageUrl = try await ImageUploader.uploadUserProfileImage(for: .Thread, image, userId: uid, uid: UUID().uuidString) else { return }
            imageUrl = uploadedImageUrl
        }
        
        var thread = Thread(
            ownerUid: uid,
            content: content,
            timestamp: Timestamp(),
            likes: 0,
            reposts: 0,
            shares: 0,
            replyCount: 0
        )
        
        if let imageUrl {
            thread.imageUrl = imageUrl
        }
        
        guard let threadDocumentRef = try await ThreadService.upload(thread) else { return }
                
        let snapshot = try await threadDocumentRef.getDocument()
        var newlyAddedThread = try snapshot.data(as: Thread.self)
        
        newlyAddedThread.user = UserService.shared.currentUser
        
        newThread = newlyAddedThread
    }
    
}
