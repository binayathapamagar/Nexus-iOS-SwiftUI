//
//  Thread.swift
//  Nexus
//
//  Created by BINAYA THAPA MAGAR on 2024-10-10.
//
import Firebase
import FirebaseFirestore

struct Thread: Identifiable, Hashable, Codable {
    //Using the document id as the threadId and it has to be an
    //optional when we use the property wrapper
    @DocumentID var threadId: String?
    let ownerUid: String
    let content: String
    let timestamp: Timestamp//From Firebase
    
    var likes: Int
    var reposts: Int
    var shares: Int
    var replyCount: Int
    
    //This property is only for the client-side and will not be
    //persisted in the database. It will be unique to the individual
    //users that consumes a particular thread.
    var didLike: Bool? = false
    var didRepost: Bool? = false
    
    //The user is an optional for performance purposes. To
    //load the thread data without initializing the user.
    //This will allow us to fetch the threads, update the UI,
    
    //Then fetch the users asynchronously and update the UI.
    
    //If the user was not optional, this will be a
    //synchronous process where we fetch the threads,
    //fetch the users and then update the UI.
    
    //The process will be longer, we wouldn't be able to use
    //the Codable protocol
    var user: User?
    var imageUrl: String?
    
    //Need this id for the Identifiable protocol
    var id: String {
        threadId ?? NSUUID().uuidString
    }
    
}
