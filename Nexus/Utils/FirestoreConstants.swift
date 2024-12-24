//
//  Constants.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-16.
//

import Firebase

struct FirestoreConstants {
    
    private static let Root = Firestore.firestore()
    
    static let LikesFieldName = "likes"
    static let TimestampFieldName = "timestamp"
    static let OwnerUidFieldName = "ownerUid"
    static let ThreadReplyOwnerUidFieldName = "threadReplyOwnerUid"
    
    static let ThreadIdName = "threadId"
    static let ThreadLikeCountName = "likes"
    static let ThreadReplyCountName = "replyCount"
    static let ThreadRepostCountName = "reposts"
    static let ThreadDidRepostName = "didRepost"
    static let ThreadLikeOwnerUidName = "threadLikeOwnerUid"
    static let ThreadReplyOwnerUidName = "threadReplyOwnerUidName"
    static let ThreadRepostOwnerUidName = "threadRepostOwnerUid"
    
    static let UserFollowingFieldName = "following"
    static let UserFollowersFieldName = "followers"
    
    static let UserFollowingCollectionName = "following"
    static let UserFollowersCollectionName = "followers"
    static let NotificationCollectionName = "notifications"
        
    static let UserCollection = Root.collection("users")
    static let ThreadCollection = Root.collection("threads")
    static let LikeCollection = Root.collection("likes")
    static let RepostCollection = Root.collection("reposts")
    static let FollowersCollection = Root.collection("followers")
    static let FollowingCollection = Root.collection("following")
    static let RepliesCollection = Root.collection("replies")
    static let ActivityCollection = Root.collection("activity")
    static let NotificationCollection = Root.collection("notifications")
}

