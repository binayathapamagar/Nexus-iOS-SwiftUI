//
//  ThreadService.swift
//  Nexus0
//
//  Created by BINAYA THAPA MAGAR on 2024-10-10.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

//Reason this is a struct instead of a class is because we are not
//going to make this a singleton class. It's only role is to be
//fetching, uploading, increaseing/decreaseing likes, reposts, comments and shares
struct ThreadService {
    private init() {}
    
    static func upload(_ thread: Thread) async throws -> DocumentReference? {
        guard let threadData = try? Firestore.Encoder().encode(thread) else { return nil }
        return try await FirestoreConstants.ThreadCollection.addDocument(data: threadData)
    }
}

// MARK: - Threads

extension ThreadService {
    static func fetchThreads() async throws -> [Thread] {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return [] }
        
        // Fetch all of the user's following
        let userFollowingSnapshot = try await UserService.followingCollectionOf(userId: currentUserUid).getDocuments()
        
        // Collect the IDs of the current user and their following
        var userIds = [currentUserUid]
        userIds.append(contentsOf: userFollowingSnapshot.documents.map { $0.documentID })
        
        guard !userIds.isEmpty else {
            return []
        }
        
        // Fetch threads concurrently for better performance
        let threads = try await withThrowingTaskGroup(of: [Thread].self) { group in
            for userId in userIds {
                group.addTask {
                    return try await fetchUserThreads(with: userId)
                }
            }
            
            var allThreads = [Thread]()
            for try await userThreads in group {
                allThreads.append(contentsOf: userThreads)
            }
            return allThreads
        }
        
        return threads.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) //newer timestamps appear before older ones
    }

    
    static func fetchThread(threadId: String) async throws -> Thread {
        let snapshot = try await FirestoreConstants
            .ThreadCollection
            .document(threadId)
            .getDocument()
        
        return try snapshot.data(as: Thread.self)
    }
    
    static func fetchUserThreads(with uid: String) async throws -> [Thread] {
        let snapshot = try await FirestoreConstants
            .ThreadCollection
            .whereField(FirestoreConstants.OwnerUidFieldName, isEqualTo: uid) //When we use whereField query, we can't order the data by a field.
            .getDocuments()
        
        let threads = snapshot.documents.compactMap({ try? $0.data(as: Thread.self )})
        return threads.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() }) //newer timestamps appear before older ones
    }
}

// MARK: - Replies

extension ThreadService {
    static func fetchThreadReplies(forUser user: User) async throws -> [ThreadReply] {
        let snapshot = try await FirestoreConstants
            .RepliesCollection
            .whereField(FirestoreConstants.ThreadReplyOwnerUidFieldName, isEqualTo: user.id)
            .getDocuments()
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: ThreadReply.self )})
        
        for i in 0..<replies.count {
            replies[i].replyUser = user//All of the replies belong to this user.
        }
        
        replies.sort { $0.timestamp.dateValue() > $1.timestamp.dateValue() }
        
        return replies
    }
}
