//
//  Like.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-25.
//

import Firebase
import FirebaseFirestore

struct Like: Identifiable, Codable {
    @DocumentID var repostId: String?
    let threadId: String
    let threadOwnerUid: String
    let threadLikeOwnerUid: String
    let timestamp: Timestamp
    
    var threadOwner: User?
    
    var id: String { repostId ?? NSUUID().uuidString }
}
