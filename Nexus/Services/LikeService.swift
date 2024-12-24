//
//  LikeService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-25.
//

import Firebase
import FirebaseAuth

struct LikeService {
    
    private init() {}
    
    static func likeThread(_ thread: Thread, with like: Like) async throws {
        guard let uid = Auth.auth().currentUser?.uid, let user = UserService.shared.currentUser else { return }

        guard let likeData = try? Firestore.Encoder().encode(like) else { return }
        
        async let _ = try await FirestoreConstants.LikeCollection.document().setData(likeData)
        async let _ = try await FirestoreConstants.ThreadCollection.document(thread.id).updateData(
            [
                FirestoreConstants.ThreadLikeCountName: thread.likes + 1
            ]
        )
        
        let notification = Notification(
            type: "like",
            ownerId: thread.ownerUid,
            senderId: uid,
            timestamp: Timestamp(),
            message: "\(user.fullName) liked your thread.",
            threadId: thread.id
        )
        
        try await NotificationService.sendNotification(notification)
    }
    
    static func unLikeThread(_ thread: Thread) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let snapshot = try await FirestoreConstants.LikeCollection
            .whereField(FirestoreConstants.ThreadIdName, isEqualTo: thread.id)
            .whereField(FirestoreConstants.ThreadLikeOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        let userLikes = snapshot.documents.compactMap({ try? $0.data(as: Like.self )})
        
        if let likedThread = userLikes.first {
            async let _ = try await FirestoreConstants.LikeCollection.document(likedThread.id).delete()
            async let _ = try await FirestoreConstants.ThreadCollection.document(thread.id).updateData(
                [
                    FirestoreConstants.ThreadLikeCountName: thread.likes - 1
                ]
            )
        }
    }
    
    static func userHasLikedThread(_ thread: Thread) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirestoreConstants.LikeCollection
            .whereField(FirestoreConstants.ThreadIdName, isEqualTo: thread.id)
            .whereField(FirestoreConstants.ThreadLikeOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        return !snapshot.documents.isEmpty
    }
    
    static func fetchUserLikedThreads(withUserUid uid: String) async throws -> [Thread] {
        let snapshot = try await FirestoreConstants.LikeCollection
            .whereField(FirestoreConstants.ThreadLikeOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        var likedData = snapshot.documents.compactMap({ try? $0.data(as: Like.self )})

        if likedData.isEmpty { return [] }//Means user has not liked any threads.
        
        likedData.sort { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        
        var likedThreads = [Thread]()
        
        // Parallel fetching for threads
        try await withThrowingTaskGroup(of: (Thread, User?).self) { group in
            for like in likedData {
                group.addTask {
                    // Fetch the thread by ID
                    let thread = try await ThreadService.fetchThread(threadId: like.threadId)
                    
                    // Fetch the user (thread owner) for each thread
                    let threadOwner = try await UserService.fetchUser(with: thread.ownerUid)
                    
                    // Return both thread and user
                    return (thread, threadOwner)
                }
            }
            
            // Step 4: Collect the results
            for try await (thread, threadOwner) in group {
                var updatedThread = thread
                updatedThread.user = threadOwner // Assign the fetched user to the thread
                likedThreads.append(updatedThread)
            }
        }
                        
        return likedThreads
    }
    
}
