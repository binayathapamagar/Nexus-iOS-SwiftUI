//
//  UserService.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-09-26.
//

import FirebaseAuth
import FirebaseFirestore

class UserService {
        
    //Not the firebase user and our own custom user model
    //that will be used to populate our app
    @Published var currentUser: User?
        
    static let shared = UserService()
    
    init() {
        if currentUser == nil {
            Task { try await fetchCurrentUser() }
        }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants
            .UserCollection.document(uid)
            .getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
        
        print(#function, "DEBUG: User is \(user)")
    }
    
    static func fetchUsers() async throws -> [User] {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await FirestoreConstants
            .UserCollection
            .getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        return users.filter({ $0.id != currentUserUid })
    }
    
    static func fetchUser(with uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants
            .UserCollection
            .document(uid)
            .getDocument()
        return try snapshot.data(as: User.self)
    }
    
    func resetCurrentUser() {
        self.currentUser = nil
    }
    
    @MainActor
    func updateUserProfile(with data: [String: Any]) async throws {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        
        try await FirestoreConstants
            .UserCollection
            .document(currentUserUid)
            .updateData(data)
        
        if let updatedUser = try await fetchUpdatedUser(with: currentUserUid) {
            self.currentUser = updatedUser
        }
    }

    private func fetchUpdatedUser(with userId: String) async throws -> User? {
        let snapshot = try await FirestoreConstants
            .UserCollection
            .document(userId)
            .getDocument()
        return try snapshot.data(as: User.self)
    }
}

// MARK: - Followers & Following

extension UserService {
    
    ///Returns the collection that contains all of the users followed by the user of the userId.
    static func followingCollectionOf(userId: String) -> CollectionReference {
        FirestoreConstants
            .FollowingCollection
            .document(userId)
            .collection(
                FirestoreConstants.UserFollowingCollectionName
            )
    }
//    
//    func getUserFollowingCountWith(userId: String) async throws {
//        let snapshot = try await UserService
//            .followingCollectionOf(userId: userId)
//            .getDocuments()
//        self.followingCount = snapshot.documents.count
//    }
    
    ///Returns the collection that contains all of the follwoers of the user.
    static func followersCollectionOf(userId: String) -> CollectionReference {
        FirestoreConstants
            .FollowersCollection
            .document(userId)
            .collection(
                FirestoreConstants.UserFollowersCollectionName
            )
    }
    
    func getUserFollowersCountWith(userId: String) async throws -> Int {
        let snapshot = try await UserService
            .followersCollectionOf(userId: userId)
            .getDocuments()
        return snapshot.documents.count
    }
    
    ///Getting the selectes user's document that the current logged-in user is following
    static func getFollowingId(userId: String) -> DocumentReference {
        FirestoreConstants
            .FollowingCollection
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection(
                FirestoreConstants.UserFollowingCollectionName
            )
            .document(userId)
    }
    
    ///Getting the current logged-in user's document from the userId followers collection
    static func getFollowersId(userId: String) -> DocumentReference {
        FirestoreConstants
            .FollowersCollection
            .document(userId)
            .collection(
                FirestoreConstants.UserFollowersCollectionName
            )
            .document(Auth.auth().currentUser?.uid ?? "")
    }
    
}
