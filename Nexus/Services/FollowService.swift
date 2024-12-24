//
//  FollowService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-12-04.
//

import Firebase
import FirebaseAuth

struct FollowService {
    
    private init() {}
    
    static func checkIfFollowingUserWith(userId: String) async throws -> Bool {
        let snapshot = try await UserService.getFollowingId(userId: userId).getDocument()
        return snapshot.exists
    }
    
    static func followUserWith(selectedUser: User) async throws {
        guard let loggedInUser = UserService.shared.currentUser else { return }
        
        async let _ = try await UserService.getFollowingId(userId: selectedUser.id).setData([:])
        async let _ = try await UserService.getFollowersId(userId: selectedUser.id).setData([:])
        
        //Updating selected user's followers count
        async let _ = try await FirestoreConstants
            .UserCollection
            .document(selectedUser.id)
            .updateData([
                FirestoreConstants.UserFollowersFieldName : selectedUser.followers + 1
            ])
        
        //Updating logged-in user's following count
        async let _ = try await UserService.shared.updateUserProfile(with: [
            FirestoreConstants.UserFollowingFieldName: loggedInUser.following + 1
        ])
        
        let notification = Notification(
            type: "follow",
            ownerId: selectedUser.id,
            senderId: loggedInUser.id,
            timestamp: Timestamp(),
            message: "\(loggedInUser.fullName) followed you."
        )
        
        try await NotificationService.sendNotification(notification)
    }
    
    static func unFollowUserWith(selectedUser: User) async throws {
        guard let loggedInUser = UserService.shared.currentUser else { return }

        async let _ = try await UserService.getFollowingId(userId: selectedUser.id).getDocument().reference.delete()
        async let _ = try await UserService.getFollowersId(userId: selectedUser.id).getDocument().reference.delete()
        
        //Updating selected user's followers count
        async let _ = try await FirestoreConstants
            .UserCollection
            .document(selectedUser.id)
            .updateData([
                FirestoreConstants.UserFollowersFieldName : selectedUser.followers - 1
            ])
        
        //Updating logged-in user's following count
        async let _ = try await UserService.shared.updateUserProfile(with: [
            FirestoreConstants.UserFollowingFieldName: loggedInUser.following - 1
        ])
    }
    
    static func fetchFollowers(withUserId userId: String) async throws -> [User] {        
        let followersSnapshot = try await UserService.followersCollectionOf(userId: userId).getDocuments()
        let followerIds = followersSnapshot.documents.map { $0.documentID }
        
        if followerIds.isEmpty { return [] }
        
        var userFollowers = [User]()
        try await withThrowingTaskGroup(of: User?.self) { group in
            for followerId in followerIds {
                group.addTask {
                    try await UserService.fetchUser(with: followerId)
                }
            }
            
            for try await follower in group {
                if let follower = follower {
                    userFollowers.append(follower)
                }
            }
        }
        
        return userFollowers
    }
    
}
