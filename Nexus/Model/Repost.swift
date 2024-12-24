//
//  Repost.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-11-22.
//

import Firebase
import FirebaseFirestore

struct Repost: Identifiable, Codable {
    @DocumentID var repostId: String?
    let threadId: String
    let threadOwnerUid: String
    let threadRepostOwnerUid: String
    let timestamp: Timestamp
    
    var threadOwner: User?
    
    var id: String { repostId ?? NSUUID().uuidString }
}
