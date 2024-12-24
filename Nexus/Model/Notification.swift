//
//  Notification.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-04.
//

import Foundation
import FirebaseFirestore

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
    let type: String // "like", "reply", "repost", "follow"
    let ownerId: String
    let senderId: String
    let timestamp: Timestamp
    let message: String
    
    var threadId: String?
    var replyId: String?
    
    var filterType: ActivityFilterOption {
        switch type {
        case ActivityFilterOption.follow.rawName:
            return .follow
        case ActivityFilterOption.reply.rawName:
            return .reply
        case ActivityFilterOption.repost.rawName:
            return .repost
        case ActivityFilterOption.like.rawName:
            return .like
        default:
            return .all
        }
    }
    
    var notificationOwner: User?
    var sender: User?
    
    var thread: Thread?
}
