//
//  ThreadReplyService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-24.
//

import FirebaseAuth
import FirebaseFirestore

enum ReplyType {
    case thread
    case user
}

struct ThreadReplyService {
    
    static func uploadThreadReply(_ threadReply: ThreadReply, to thread: Thread) async throws -> DocumentReference? {
        guard let user = UserService.shared.currentUser else { return nil }
        guard let replyData = try? Firestore.Encoder().encode(threadReply) else { return nil }
        
        async let replyDocumentRef = try await FirestoreConstants.RepliesCollection.addDocument(data: replyData)
        async let _ = try await FirestoreConstants.ThreadCollection.document(thread.id).updateData(
            [
                FirestoreConstants.ThreadReplyCountName: thread.replyCount + 1
            ]
        )
        
        let notification = Notification(
            type: "reply",
            ownerId: threadReply.threadOwnerUid,
            senderId: threadReply.threadReplyOwnerUid,
            timestamp: Timestamp(),
            message: "\(user.fullName) replied to your thread.",
            threadId: thread.id,
            replyId: threadReply.id
        )
        
        try await NotificationService.sendNotification(notification)
        
        return try await replyDocumentRef
    }
    
    static func fetchReplies(for thread: Thread? = nil, for user: User? = nil, replyType: ReplyType) async throws -> [ThreadReply] {
        let id: String = {
            switch replyType {
            case .thread:
                return thread?.id ?? ""
            case .user:
                return user?.id ?? ""
            }
        }()
        
        let snapshot = try await FirestoreConstants
            .RepliesCollection
            .whereField(
                replyType == .thread ? FirestoreConstants.ThreadIdName : FirestoreConstants.ThreadReplyOwnerUidName,
                isEqualTo: id
            )
            .getDocuments()
        
        var replies = snapshot.documents.compactMap { try? $0.data(as: ThreadReply.self) }
        
        replies.sort { $0.timestamp.dateValue() > $1.timestamp.dateValue() }

        return replies
    }
    
}
