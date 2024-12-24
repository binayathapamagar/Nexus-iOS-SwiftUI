//
//  PreviewProvider.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-07.
//

import SwiftUI
import Firebase

//extension PreviewProvider {
//    static var dev: DeveloperPreview {
//        return DeveloperPreview.shared
//    }
//}

class DeveloperPreview {
    
    static let shared = DeveloperPreview()
    
    let user = User(
        id: UUID().uuidString,
        username: "leo_messi",
        fullName: "Leo Andres Messi",
        email: "messi@gmail.com",
        joinedDate: "July 23, 2024",
        profileImageUrl: "https://static.wikia.nocookie.net/p__/images/6/61/RUSHHOURHD.jpg/revision/latest?cb=20240618210443&path-prefix=protagonist"
    )
    
    lazy var thread = Thread(
        ownerUid: NSUUID().uuidString,
        content: "This is a test thread for the test user to use for development purposes.",
        timestamp: Timestamp(),
        likes: 100,
        reposts: 1000,
        shares: 200,
        replyCount: 250,
        user: user,
        imageUrl: "https://static.vecteezy.com/system/resources/previews/036/804/331/non_2x/ai-generated-assorted-indian-food-on-dark-wooden-background-free-photo.jpg"
    )
    
    lazy var threadReply = ThreadReply(
        threadId: NSUUID().uuidString,
        replyText: "This is a test thread reply for the test user to use for development purposes.",
        threadReplyOwnerUid: NSUUID().uuidString,
        threadOwnerUid: NSUUID().uuidString,
        timestamp: Timestamp(),
        thread: thread,
        replyUser: user
    )
    
    lazy var notification = Notification(
        id: NSUUID().uuidString,
        type: "like",
        ownerId: NSUUID().uuidString,
        senderId: NSUUID().uuidString,
        timestamp: Timestamp(),
        message: "User liked your thread",
        notificationOwner: user
    )
}
