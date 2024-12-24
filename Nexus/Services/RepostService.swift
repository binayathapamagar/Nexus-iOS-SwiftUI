//
//  RepostService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-22.
//

import Firebase
import FirebaseAuth

struct RepostService {
    
    private init() {}
    
    static func repostThread(_ thread: Thread, with repost: Repost) async throws {
        guard let user = UserService.shared.currentUser else { return }
        guard let repostData = try? Firestore.Encoder().encode(repost) else { return }
        
        async let _ = try await FirestoreConstants.RepostCollection.document().setData(repostData)
        async let _ = try await FirestoreConstants.ThreadCollection.document(thread.id).updateData(
            [
                FirestoreConstants.ThreadRepostCountName: thread.reposts + 1
            ]
        )
        
        let notification = Notification(
            type: "repost",
            ownerId: repost.threadOwnerUid,
            senderId: user.id,
            timestamp: Timestamp(),
            message: "\(user.fullName) reposted your thread.",
            threadId: thread.id
        )
        
        try await NotificationService.sendNotification(notification)
    }
    
    static func unRepostThread(_ thread: Thread) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let snapshot = try await FirestoreConstants.RepostCollection
            .whereField(FirestoreConstants.ThreadIdName, isEqualTo: thread.id)
            .whereField(FirestoreConstants.ThreadRepostOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        let reposts = snapshot.documents.compactMap({ try? $0.data(as: Repost.self )})
        
        if let repostedThread = reposts.first {
            async let _ = try await FirestoreConstants.RepostCollection.document(repostedThread.id).delete()
            async let _ = try await FirestoreConstants.ThreadCollection.document(thread.id).updateData(
                [
                    FirestoreConstants.ThreadRepostCountName: thread.reposts - 1
                ]
            )
        }
    }
    
    static func userHasRepostedThread(_ thread: Thread) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirestoreConstants.RepostCollection
            .whereField(FirestoreConstants.ThreadIdName, isEqualTo: thread.id)
            .whereField(FirestoreConstants.ThreadRepostOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        return !snapshot.documents.isEmpty
    }
    
    static func fetchUserRepostedThreads(withUserUid uid: String) async throws -> [Thread] {
        let snapshot = try await FirestoreConstants.RepostCollection
            .whereField(FirestoreConstants.ThreadRepostOwnerUidName, isEqualTo: uid)
            .getDocuments()
        
        var repostedData = snapshot.documents.compactMap({ try? $0.data(as: Repost.self )})

        if repostedData.isEmpty { return [] }//Means user has not reposted any threads.
        
        repostedData.sort { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        
        var repostedThreads = [Thread]()
        
        // Parallel fetching for threads
        try await withThrowingTaskGroup(of: (Thread, User?).self) { group in
            for repost in repostedData {
                group.addTask {
                    // Fetch the thread by ID
                    let thread = try await ThreadService.fetchThread(threadId: repost.threadId)
                    
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
                repostedThreads.append(updatedThread)
            }
        }
                        
        return repostedThreads
    }
    
}
