//
//  ThreadReply.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-24.
//

import Firebase
import FirebaseFirestore

struct ThreadReply: Identifiable, Codable {
    @DocumentID var replyId: String?
    let threadId: String
    let replyText: String
    let threadReplyOwnerUid: String
    let threadOwnerUid: String
    let timestamp: Timestamp
    
    var imageUrl: String?
    
    //Client side properties that will not be persisted in the Firestore database.
    var thread: Thread?
    var replyUser: User?
    
    var id: String { replyId ?? NSUUID().uuidString }
}
